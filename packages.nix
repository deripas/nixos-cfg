{ pkgs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;
  
  # Zsh
  programs.zsh.enable = true;

  # Steam
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flatpak
  services.flatpak.enable = true;
#  services.flatpak.remotes = {
#    flathub = {
#      url = "https://flathub.org/repo/flathub.flatpakrepo";
#    };
#  };
 
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    git
    mc
    zsh
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-fzf-history-search
    zsh-powerlevel10k
    meslo-lgs-nf
    fzf
    wget
    curl
    htop
    btop
    tree
    pciutils
    usbutils
    file
    unzip
    neofetch
    distrobox
  ];
}
