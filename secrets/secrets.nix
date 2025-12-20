let
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKORNfcvu2zmTC3DU9vWeCTgFr0Abh5MRmo65C7jqJRC";
  keys = [macbook];
in {
  "restic-repositories.age".publicKeys = keys;
}
