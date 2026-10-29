{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mc
    nano
    vim
    tree
    git
    ripgrep
    adr-tools

    # dev
    protobuf
    grpcurl
    golangci-lint
    k6
    uv

    # cloud / k8s
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    kubectl
    kubectx
    docker-client
    glab
  ];
}
