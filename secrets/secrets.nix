let
  bnjmnt4n = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe6hIIUoeG7hBpGioOuOoO3Rt3iAdn3F0Jep8uc1stj";
  raspy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGH7rCefDGFPAfIbBL544Q7MEyXXfvG+PaEIsHqQw1m";
  windows = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUQE91NQrRSptjAMQLWkbUaf2LbZZBuwU7CkxxOh2QZ";
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINrmkjPpijnE+TBVU2i0I4zbqVkX4lBgleAY97x6YlyP";
  keys = [ bnjmnt4n raspy windows ];
in
{
  "wireguard-private-key.age".publicKeys = keys;
  "b2-repo.age".publicKeys = keys;
  "b2-account-id.age".publicKeys = keys;
  "b2-account-key.age".publicKeys = keys;
}
