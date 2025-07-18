resource "azurerm_resource_group" "rsg-one" {
    name = var.rsgname1
    location = var.location1
  
}

resource "azurerm_virtual_network" "vnet-one" {
    name = var.vnetname1
    location = azurerm_resource_group.rsg-one.location
    address_space = var.vnetaddress1
    resource_group_name = azurerm_resource_group.rsg-one.name
  
}

resource "azurerm_subnet" "public_subnets" {
  count                = 2
  name                 = "public-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.rsg-one.name
  virtual_network_name = azurerm_virtual_network.vnet-one.name
  address_prefixes     = [var.public_subnet_prefixes[count.index]]
}

resource "azurerm_nat_gateway" "nat_gw" {
    name = "natgateway"
    location = azurerm_resource_group.rsg-one.location
    resource_group_name = azurerm_resource_group.rsg-one.name
    sku_name = "Standard"
  
}

resource "azurerm_subnet" "private_subnets" {
  count                = 2
  name                 = "private-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.rsg-one.name
  virtual_network_name = azurerm_virtual_network.vnet-one.name
  address_prefixes     = [var.private_subnet_prefixes[count.index]]

}

resource "azurerm_subnet_nat_gateway_association" "nat-ass" {
    count = 2
    subnet_id = azurerm_subnet.private_subnets[count.index].id
    nat_gateway_id = azurerm_nat_gateway.nat_gw.id
  
}

resource "azurerm_route_table" "rt" {
    count = 4
    name = "rt-${count.index+1}"
    location = azurerm_resource_group.rsg-one.location
    resource_group_name = azurerm_resource_group.rsg-one.name
  
}

resource "azurerm_subnet_route_table_association" "rt-ass-pub" {
    count = 2
    subnet_id = azurerm_subnet.public_subnets[count.index].id
    route_table_id = azurerm_route_table.rt[count.index].id
  
}

resource "azurerm_subnet_route_table_association" "rt-ass-priv" {
    count = 2
    subnet_id = azurerm_subnet.private_subnets[count.index].id
    route_table_id = azurerm_route_table.rt[count.index+2].id
  
}

resource "azurerm_network_security_group" "nsgone" {
        count = 4
        name                = "nsg-${count.index+1}"
        location            = azurerm_resource_group.rsg-one.location
        resource_group_name = azurerm_resource_group.rsg-one.name

        dynamic "security_rule" {
        for_each = [values(var.security_rules)[count.index]]
        content {
        name                       = security_rule.value.name
        priority                   = security_rule.value.priority
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = security_rule.value.port
        source_address_prefix      = "*"
        destination_address_prefix = "*"
        }
  }
}          


resource "azurerm_subnet_network_security_group_association" "nsg_assoc_pub" {
  count                = 2
  subnet_id            = azurerm_subnet.public_subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsgone[count.index].id
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_priv" {
  count                = 2
  subnet_id            = azurerm_subnet.private_subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsgone[count.index+2].id
}
