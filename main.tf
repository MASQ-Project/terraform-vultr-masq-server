#  Vultr Docs
#  https://registry.terraform.io/providers/vultr/vultr/latest/docs
# | python -m json.tool






terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.9.1"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key = ""
  rate_limit = 700
  retry_limit = 3
}


resource "random_integer" "port" {
  min = 1025
  max = 65000
}


# Testing Added Firewall Rules
resource "vultr_firewall_group" "node_firewall" {
    description = "Terra-Firewall"
}

resource "vultr_firewall_rule" "firewallrule0" {
    firewall_group_id = vultr_firewall_group.node_firewall.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "0.0.0.0"
    subnet_size = 0
    port = "22"
    notes = "Enable SSH"
}

resource "vultr_firewall_rule" "firewallrule1" {
    firewall_group_id = vultr_firewall_group.node_firewall.id
    protocol = "tcp"
    ip_type = "v4"
    subnet = "0.0.0.0"
    subnet_size = 0
    port = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    notes = "Enable MASQ Clandestine Port v4"
}

resource "vultr_firewall_rule" "firewallrule2" {
    firewall_group_id = vultr_firewall_group.node_firewall.id
    protocol = "tcp"
    ip_type = "v6"
    subnet = "::"
    subnet_size = 0
    port = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    notes = "Enable MASQ Clandestine Port v6"
}





# Creates Basic instance, Ubuntu 21, Melbourne 
resource "vultr_instance" "my_instance" {
    plan                 = "vc2-1c-1gb"      # vc2-1c-1gb
    region               = "mel"             # Melbourne
    os_id                = "517"             # Ubuntu 21.10 x64
    firewall_group_id    = vultr_firewall_group.node_firewall.id

    user_data = templatefile("${path.module}/config.tpl", {
       chain              = var.chain
       bcsurl             = var.bcsurl
       clandestine_port   = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
       dbpass             = var.dbpass
       dnsservers         = var.dnsservers
       earnwallet         = var.earnwallet
       downloadurl        = var.downloadurl
       gasprice           = var.gasprice
       conkey             = var.conkey
       mnemonic           = var.mnemonic
       centralLogging     = var.centralLogging
       centralNighbors    = var.centralNighbors
       customnNighbors    = var.customnNighbors
      #  agent_config       = base64encode(file("${path.module}/amazon-cloudwatch-agent.json"))    #TODO
      agent_config         = ""                                                                    #TODO
      #  index              = count.index                                                          #TODO
      #  mnemonicAddress    = element(var.mnemonic_list, count.index)                              #TODO
      #  earnwalletAddress  = element(var.earnwallet_list, count.index)                            #TODO

        mnemonicAddress = ""           #TODO
        earnwalletAddress = ""         #TODO
  })

  


}
