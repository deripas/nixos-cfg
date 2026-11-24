{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mc
    nano
    vim
    tree
    broot
    git
    ripgrep
    adr-tools

    # dev
    protobuf
    grpcurl
    golangci-lint
    k6
    uv
    nodejs_26
    pnpm
    yarn
    go_1_26

    # cloud / k8s
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    kubectl
    kubectx
    docker-client
    glab

    qpdf
    ghostscript
  ];
}
