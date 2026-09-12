{ config, pkgs, ... }:

{
  # Открываем 80 порт в файрволе
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    
    virtualHosts."server.fantail-exponential.ts.net".extraConfig = ''
      reverse_proxy 127.0.0.1:2283
    '';
    
    virtualHosts."http://:80" = {
      extraConfig = ''
        #tls internal

        # ГЛАВНАЯ СТРАНИЦА
        handle / {
          header Content-Type "text/html; charset=utf-8"
          respond `
            <!DOCTYPE html>
            <html lang="ru">
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
              <title>Server Dashboard</title>
              <style>
                body { font-family: system-ui, sans-serif; background: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; }
                .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; width: 100%; max-width: 800px; padding: 20px; }
                .card { background: #1e293b; border-radius: 12px; padding: 24px; text-align: center; text-decoration: none; color: white; border: 1px solid #334155; transition: transform 0.2s, border-color 0.2s; }
                .card:hover { transform: translateY(-4px); border-color: #38bdf8; }
                .card h2 { margin: 0 0 8px 0; font-size: 1.25rem; }
                .card p { margin: 0; color: #94a3b8; font-size: 0.875rem; }
              </style>
            </head>
            <body>
              <div class="grid">
                <a href="/immich" class="card">
                  <h2>Immich</h2>
                  <p>Фото и видео</p>
                </a>
                <a href="/pgadmin/" class="card">
                  <h2>pgAdmin</h2>
                  <p>Управление PostgreSQL</p>
                </a>
              </div>
            </body>
            </html>
          ` 200
        }

        handle_path /pgadmin* {
          reverse_proxy 127.0.0.1:5050 {
            header_up X-Script-Name /pgadmin
          }
        }

        handle /immich* {
          redir http://{host}:2283 302
        }
      '';
    };

  };

}
