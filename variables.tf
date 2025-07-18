variable "client_id" {
   default = "a99759f7-b167-475d-b13d-48fc210b72cf"
 }

variable "client_secret" {
   default = "PTU8Q~pplkg5cQL8NgAB1ELCXq1a2Cq._kSMEbSM"
 }

variable "tenant_id" {
   default = "d9f4eeac-86fb-4e06-a609-36ad11be3806"
 }

variable "subscription_id" {
   default = "4244d912-5292-4f0e-be57-7108812c7a6b"
 }

variable "rsgname1" {
  
}

variable "location1" {
  
}

variable "vnetname1" {
  
}

variable "vnetaddress1" {
  
}

variable "public_subnet_prefixes" {
    type = list(string)

}

variable "private_subnet_prefixes" {
    type = list(string)

}

variable "security_rules" {
   type = map(object({
       name = string
       priority = number
       port = string
   }))
 }
 
