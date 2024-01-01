{ ... }:

{
  age.secrets.wireguard-private-key = {
    file = ../../secrets/wireguard-private-key.age;
  };
  age.secrets.b2-repo = {
    file = ../../secrets/b2-repo.age;
    owner = "bnjmnt4n";
  };
  age.secrets.b2-account-id = {
    file = ../../secrets/b2-account-id.age;
    owner = "bnjmnt4n";
  };
  age.secrets.b2-account-key = {
    file = ../../secrets/b2-account-key.age;
    owner = "bnjmnt4n";
  };
}
