let 
  mihranmashhud_mihranDesktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMjUrT9+0KhuHJX7/ZF6AHj1sciaR6mWxtpmQ5FPAZ/";
  mihranmashhud_mihranLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKb3yceGO77BjZ9jK8bufIWgoRLS/qI2nMwCQD588Q3Z";
  mihranmashhud_mihranServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZYhUpSOHcjWS9g7mDiRU1qqIygduD9UEBARH4chInH";
  mihranDesktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQAgc7pHrpg4E7TrZvZDRnsz/lANEPljiOPMfpNIJJX";
  mihranServer = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+8KwQLLf8DhHtQxgf5Fj+8FIstQ0cYL1nCoNYDMCae";
  users = [
    mihranmashhud_mihranDesktop
    mihranmashhud_mihranLaptop
    mihranmashhud_mihranServer
  ];
  systems = [
    mihranDesktop
    mihranServer
  ];
in {
  "cloudflared-tunnel.age".publicKeys = users ++ [mihranServer];
  "cloudflared-cert.age".publicKeys = users ++ [mihranServer];
}
