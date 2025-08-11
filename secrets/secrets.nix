let 
  mihranmashhud_mihranDesktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMjUrT9+0KhuHJX7/ZF6AHj1sciaR6mWxtpmQ5FPAZ/";
  mihranmashhud_mihranLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKb3yceGO77BjZ9jK8bufIWgoRLS/qI2nMwCQD588Q3Z";
  mihranmashhud_mihranServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZYhUpSOHcjWS9g7mDiRU1qqIygduD9UEBARH4chInH";
  keys = [
    mihranmashhud_mihranDesktop
    mihranmashhud_mihranLaptop
    mihranmashhud_mihranServer
  ];
in {
  "cloudflare-tunnel.age".publicKeys = keys;
}
