#  Vultr Docs
#  https://registry.terraform.io/providers/vultr/vultr/latest/docs

terraform {
  required_providers {
    vultr = {
      source   = "vultr/vultr"
      version  = "2.9.1"
    }
  }
}

# Configure the Vultr Provider
provider "vultr" {
  api_key      = var.API_KEY
  rate_limit   = 700
  retry_limit  = 3
}
# Generatres random number for clandestine port
resource "random_integer" "port" {
  min = 1025
  max = 65000
}

# Create Firewall Group
resource "vultr_firewall_group" "node_firewall" {
    description          = "Terra-Firewall"
}

# Add Rule to Firewall Group
resource "vultr_firewall_rule" "firewallrule0" {
    firewall_group_id    = vultr_firewall_group.node_firewall.id
    protocol             = "tcp"
    ip_type              = "v4"
    subnet               = "0.0.0.0"
    subnet_size          = 0
    port                 = "22"
    notes                = "Enable SSH"
}

# Add Rule to Firewall Group
resource "vultr_firewall_rule" "firewallrule1" {
    firewall_group_id    = vultr_firewall_group.node_firewall.id
    protocol             = "tcp"
    ip_type              = "v4"
    subnet               = "0.0.0.0"
    subnet_size          = 0
    port                 = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    notes                = "Enable MASQ Clandestine Port v4"
}

# Add Rule to Firewall Group
resource "vultr_firewall_rule" "firewallrule2" {
    firewall_group_id    = vultr_firewall_group.node_firewall.id
    protocol             = "tcp"
    ip_type              = "v6"
    subnet               = "::"
    subnet_size          = 0
    port                 = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    notes                = "Enable MASQ Clandestine Port v6"
}

# Create ssh key resource
resource "vultr_ssh_key" "my_ssh_key" {
  name = var.sshKeyName
  ssh_key = var.sshKey
}

# Creates VM Instance
resource "vultr_instance" "my_instance" {
  count                = var.instance_count
  tag                  = "${var.name}"
  label                = "${var.name}-${count.index + 1}"
  hostname             = "${var.name}-${count.index + 1}"
  plan                 = var.vultr_plan
  region               = var.vultr_region
  os_id                = var.vultr_os
  firewall_group_id    = vultr_firewall_group.node_firewall.id
  ssh_key_ids          = [vultr_ssh_key.my_ssh_key.id]

  user_data = templatefile("${path.module}/config.tpl", {
    chain              = var.chain
    bcsurl             = var.bcsurl
    clandestine_port   = var.clandestine_port != null ? var.clandestine_port : random_integer.port.result
    dbpass             = var.dbpass
    dnsservers         = var.dnsservers
    downloadurl        = var.downloadurl
    gasprice           = var.gasprice
    paymentThresholds  = var.paymentThresholds
    ratePack           = var.ratePack
    scanIntervals      = var.scanIntervals
    centralLogging     = var.centralLogging
    centralNighbors    = var.centralNighbors
    customnNighbors    = var.customnNighbors
    pushDescriptor     = var.pushDescriptor
    cycleDerivation    = var.cycleDerivation
    derivationIndex    = var.derivationIndex
    masterNode         = var.masterNode
    randomNighbors     = var.randomNighbors
    index              = count.index                                  
    mnemonicAddress    = element(var.mnemonic_list, count.index)
    earnwalletAddress  = "${length(var.earnwallet_list)}" != "0" ? "" : element(var.earnwallet_list, count.index)
    earnwalletAddressindex  = "${length(var.earnwallet_list)}"
    agent_config       = ""                                                                   #TODO
    #  agent_config    = base64encode(file("${path.module}/amazon-cloudwatch-agent.json"))    #TODO
  })
}
 