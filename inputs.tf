variable "API_KEY" {
  type        = string
  default     = ""
  description = "Vultr API KEY"
}
variable "vultr_plan" {
  type        = string
  default     = "vc2-1c-1gb"
  description = "Vultr Plan ID: "
}
variable "vultr_region" {
  type        = string
  default     = "mel"
  description = "Vultr Region ID: "
}
variable "vultr_os" {
  type        = string
  default     = "387"
  description = "Vultr OS ID: "
}
variable "clandestine_port" {
  type        = number
  default     = null
  description = "This is the port you want MASQ to listen on for clandestine traffic.  This will be used for your config.toml and SG settings."
}
variable "key_name" {
  type        = list
  description = "The name of the AWS Key Pair you want to use."
  default     = [""]
}
variable "name" {
  type        = string
  description = "The name you would like to give the instance.  This is purely for use inside of AWS, it won't show on the MASQ Network."
  default     = "MASQNode"
}
variable "chain" {
  type        = string
  description = "The name of the blockchain to use, eth-mainnet, eth-ropsten, polygon-mainnet, and polygon-mumbai are the only valid options."
  default     = "polygon-mumbai"
}
variable "bcsurl" {
  type        = string
  description = "The url of the blockchain service.  This defaults to ropsten url."
  default     = "https://ropsten.infura.io/v3/0ead23143b174f6983c76f69ddcf4026"
}
variable "dbpass" {
  type        = string
  description = "The password you would like to use for the MASQ DB."
  default     = "Whynotchangeme123"
}
variable "dnsservers" {
  type        = string
  description = "The DNS servers to use to resolve URLs for requests."
  default     = "1.0.0.1,1.1.1.1,8.8.8.8,9.9.9.9"
}
variable "gasprice" {
  type        = number
  description = "The gas price you are willing to pay to settle transactions."
  default     = 50
}

variable "paymentThresholds" {
  type        = string
  description = "These are parameters that define thresholds to determine when and how much to pay other Nodes for routing"
  default     = ""
}
variable "ratePack" {
  type        = string
  description = "These four parameters specify your rates that your Node will use for charging other Nodes for your provided services"
  default     = ""
}
variable "scanIntervals" {
  type        = string
  description = "These three intervals describe the length of three different scan cycles running"
  default     = ""
}

variable "centralLogging" {
  type        = bool
  description = "Would you like to enable central logging via cloudwatch logs."
  default     = false
}
variable "customnNighbors" {
  type        = string
  description = ""
  default     = "Node Descriptors for connecting to the MASQ network. Separate with a ','"
}
variable "centralNighbors" {
  type        = bool
  description = "Gets official MASQ Node Descriptors. (customnNighbors) will be ignored"
  default     = false
}
variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default = 1
}
variable "mnemonic_list" {
  type        = list
  description = "List of mnemonic"
  default     = [""]
}
variable "earnwallet_list" {
  type = list
  description = "Array list of earnwallet"
  default = []
}
variable "downloadurl" {
  type        = string
  description = "URL of MASQ bin file, .zip formatt"
  default     = ""
}

variable "pushDescriptor" {
  type        = bool
  description = "POST's the Descriptor to Cloud Node API"
  default     = false
}

variable "cycleDerivation" {
  type        = bool
  description = "Cycles Wallet Derivation path"
  default     = false
}
variable "derivationIndex" {
  type        = number
  description = "Index Derivation Cycle Starts from"
  default     = 0
}

variable "masterNode" {
  type        = bool
  description = "Is a Master Node"
  default     = false
}

 