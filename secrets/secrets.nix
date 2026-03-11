let
  lukas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4KVXdfWDiiutbuh8RGMqt4qWT/LGgYNzMI/XHvVN+4";
  systems = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJviUd0r4rvj+lyut2CASi3mqk2zQGZSf5DEu2nBfV2P" ];
in {
  "github-token.age".publicKeys = [ lukas ] ++ systems;
}
