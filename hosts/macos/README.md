# macOS (nix-darwin)

Конфигурация рабочего Mac на [nix-darwin](https://github.com/nix-darwin/nix-darwin).
Без flake, на каналах — так же, как NixOS-хосты в этом репозитории.

```
hosts/macos/
├── default.nix   # импорты + system.stateVersion
├── nix.nix       # nix.conf, gc, optimise
├── pkgs.nix      # системные пакеты
└── fonts.nix     # шрифты
```

Из `core/` подключается только то, что работает на darwin
(сейчас `core/development/go.nix`). Остальное в `core/` — NixOS-специфичное
(boot, networking, desktop, systemd-сервисы), импортировать его нельзя.

## Установка с нуля

### 1. Nix

Официальный установщик (multi-user):

```sh
sh <(curl -L https://nixos.org/nix/install)
```

Он создаёт отдельный зашифрованный APFS-том `Nix Store`, монтируемый в `/nix`,
пользователей `_nixbld*` и демон `org.nixos.nix-daemon`.

> Determinate Nix installer тоже подходит, но тогда в конфиге нужно
> `nix.enable = false;` — Nix управляет он, а не nix-darwin.

### 2. Каналы

nix-darwin запускается от root, поэтому каналы — root'овые:

```sh
sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
sudo nix-channel --add https://github.com/nix-darwin/nix-darwin/archive/master.tar.gz darwin
sudo nix-channel --update
```

### 3. Репозиторий в `/etc/nix-darwin`

nix-darwin по умолчанию берёт `/etc/nix-darwin/configuration.nix`.
Клонируем репозиторий прямо туда, `configuration.nix` в `.gitignore`:

```sh
sudo mkdir -p /etc/nix-darwin
sudo chown $(id -nu):staff /etc/nix-darwin
git clone git@github.com:deripas/nixos-cfg.git /etc/nix-darwin

cat > /etc/nix-darwin/configuration.nix <<'EOF'
{ ... }:

{
  imports = [ ./hosts/macos ];
}
EOF
```

### 4. Первая активация

```sh
sudo nix-build '<darwin>' -A darwin-rebuild
sudo ./result/bin/darwin-rebuild switch
```

Скорее всего упадёт с `Unexpected files in /etc, aborting activation` —
установщик Nix дописал свои блоки в `/etc/zshrc` и `/etc/bashrc`.
nix-darwin чужие файлы не перезаписывает, их нужно убрать с дороги:

```sh
sudo mv /etc/zshrc  /etc/zshrc.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo ./result/bin/darwin-rebuild switch
```

Переименовывать **только** после ошибки: без этих файлов новый шелл не найдёт
`nix`, пока активация не пройдёт.

Если `darwin-rebuild` не в PATH (активация не завершилась), он есть в собранном профиле:

```sh
sudo /nix/var/nix/profiles/system/sw/bin/darwin-rebuild switch
```

После успешного `switch` — новый терминал, дальше просто `sudo darwin-rebuild switch`.

## Повседневное

```sh
sudo darwin-rebuild switch          # применить конфиг
darwin-rebuild build                # только собрать, без sudo/активации
sudo nix-channel --update && sudo darwin-rebuild switch   # обновить пакеты
sudo darwin-rebuild switch --rollback                     # откат
darwin-rebuild --list-generations
```

GC (`--delete-older-than 14d`, по воскресеньям) и `nix-store --optimise`
запускаются launchd'ом сами (`hosts/macos/nix.nix`).
`nix.settings.auto-optimise-store` на macOS не включаем — известны случаи порчи store.

## Нюансы и поломки

### После перезагрузки пропал `nix`, `/nix` пустой

Том `Nix Store` зашифрован (FileVault) и не разблокировался при загрузке:

```sh
diskutil info "Nix Store" | grep -E 'Mounted|Locked|Volume UUID'
#   Mounted: No / Locked: Yes
```

Монтирование держится на трёх вещах, которые создаёт установщик Nix.
Если что-то из них пропало (повторная установка, неудачный uninstall,
обновление macOS) — `/nix` не монтируется:

| Что | Зачем |
|---|---|
| `/etc/synthetic.conf` со строкой `nix` | создаёт точку монтирования `/nix` в read-only корне |
| `/etc/fstab`: `UUID=<uuid> /nix apfs rw,noauto,nobrowse,suid,owners` | параметры монтирования (`noauto` — монтирует не система, а демон ниже) |
| `/Library/LaunchDaemons/org.nixos.darwin-store.plist` | при загрузке берёт пароль тома из System keychain и разблокирует его |

Пароль тома хранится в System keychain под именем `Nix Store`
(service = UUID тома):

```sh
sudo security find-generic-password -s <UUID> /Library/Keychains/System.keychain
```

**Починка:**

```sh
UUID=$(diskutil info "Nix Store" | awk -F': *' '/Volume UUID/ {print $2}')

# смонтировать сейчас
sudo security find-generic-password -s "$UUID" -w /Library/Keychains/System.keychain \
  | sudo diskutil apfs unlockVolume "$UUID" -stdinpassphrase -mountpoint /nix

# synthetic.conf (если нет — нужна перезагрузка, чтобы появился /nix)
grep -qx nix /etc/synthetic.conf 2>/dev/null || echo nix | sudo tee -a /etc/synthetic.conf

# fstab (правильнее через `sudo vifs`)
grep -q "$UUID" /etc/fstab 2>/dev/null || \
  echo "UUID=$UUID /nix apfs rw,noauto,nobrowse,suid,owners" | sudo tee -a /etc/fstab

# демон разблокировки тома при загрузке
sudo tee /Library/LaunchDaemons/org.nixos.darwin-store.plist >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>org.nixos.darwin-store</string>
  <key>RunAtLoad</key><true/>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/sh</string><string>-c</string>
    <string>/usr/bin/security find-generic-password -s $UUID -w /Library/Keychains/System.keychain | /usr/sbin/diskutil apfs unlockVolume $UUID -stdinpassphrase -mountpoint /nix</string>
  </array>
</dict>
</plist>
EOF
sudo chown root:wheel /Library/LaunchDaemons/org.nixos.darwin-store.plist
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.darwin-store.plist

sudo launchctl kickstart -k system/org.nixos.nix-daemon
```

Проверка после перезагрузки:

```sh
mount | grep /nix
sudo launchctl print system/org.nixos.darwin-store | grep -iE 'state|exit'
```

### После обновления macOS пропал `nix` в шелле

macOS может перезаписать `/etc/zshrc` своим. nix-darwin держит его симлинком
на `/etc/static/zshrc`:

```sh
ls -la /etc/zshrc     # должно быть -> /etc/static/zshrc
```

Если нет — переименовать `/etc/zshrc` в `.before-nix-darwin` и
`sudo /nix/var/nix/profiles/system/sw/bin/darwin-rebuild switch`.

### `/run/current-system` нет после перезагрузки

`/run` → `/private/var/run` и очищается при загрузке; симлинк восстанавливает
демон `org.nixos.activate-system`. Если его нет — активация ни разу не прошла
успешно, см. «Первая активация».

### Абсолютные пути на бинарники из brew

Инструменты, которые прописывают полный путь к бинарнику, ломаются при
переезде с Homebrew. Пример — kubeconfig для GKE:

```
exec: fork/exec /opt/homebrew/share/google-cloud-sdk/bin/gke-gcloud-auth-plugin: no such file or directory
```

1. В nix `google-cloud-sdk` идёт без плагинов, их подключают явно:
   `google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ]`
   (см. `pkgs.nix`).
2. В `~/.kube/config` заменить путь на имя:
   ```sh
   sed -i '' 's#/opt/homebrew/share/google-cloud-sdk/bin/gke-gcloud-auth-plugin#gke-gcloud-auth-plugin#g' ~/.kube/config
   ```
   Если GUI-приложение (IDE) не находит плагин — у него нет nix в PATH,
   тогда прописать `/run/current-system/sw/bin/gke-gcloud-auth-plugin`.

Поиск оставшихся ссылок на brew: `grep -rn /opt/homebrew ~/.kube ~/.config ~/.*rc 2>/dev/null`.

### Переезд с Homebrew

| brew | nixpkgs |
|---|---|
| `docker` | `docker-client` (только CLI; демон — Docker Desktop) |
| `kubernetes-cli` | `kubectl` |
| `midnight-commander` | `mc` |
| cask `font-meslo-lg-nerd-font` | `fonts.packages = [ nerd-fonts.meslo-lg ]` |

Проверить, что имя есть в nixpkgs:

```sh
nix-instantiate --eval -E 'with import <nixpkgs> {}; kubectl.name'
```

Порядок переезда: добавить пакеты в конфиг → `switch` → `which -a <cmd>`
(первым должен быть `/run/current-system/sw/bin`) → `brew uninstall`.
Homebrew целиком удаляется официальным скриптом
(`uninstall.sh`, сначала с `--dry-run`), затем
`sudo rm -f /etc/paths.d/homebrew && sudo rm -rf /opt/homebrew`.

Для GUI-приложений, которых нет в nixpkgs, у nix-darwin есть модуль `homebrew`
(casks описываются декларативно, ставит их `darwin-rebuild`).
