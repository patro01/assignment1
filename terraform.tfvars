location1 = "East US"
rsgname1 = "rsg-1"
vnetaddress1 = ["10.0.0.0/16"]
public_subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_prefixes = ["10.0.3.0/24", "10.0.4.0/24"]
vnetname1 = "vnet-one"

security_rules = {
 pub1 = {
   name     = "SSH"
   priority = 100
   port     = "22"
 }
 pub2 = {
   name     = "SSH"
   priority = 101
   port     = "80"
 }

 priv1 = {
   name     = "SSH"
   priority = 102
   port     = "8080"
 }

  priv2 = {
   name     = "SSH"
   priority = 102
   port     = "8080"
 }
}
