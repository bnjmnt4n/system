let
  bnjmnt4n = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe6hIIUoeG7hBpGioOuOoO3Rt3iAdn3F0Jep8uc1stj";
  raspy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGH7rCefDGFPAfIbBL544Q7MEyXXfvG+PaEIsHqQw1m";
  keys = [ bnjmnt4n raspy ];
in
{
  "mathpix-app-id.age".publicKeys = keys;
  "mathpix-app-key.age".publicKeys = keys;
  "org-gcal-client-id.age".publicKeys = keys;
  "org-gcal-client-secret.age".publicKeys = keys;
  "wireguard-private-key.age".publicKeys = keys;
}
