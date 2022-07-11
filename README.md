## Description
This module's purpose is to automatically deploy an VM to Vultr and have it configure itself to be a node in the MASQ Network (masq.ai)

## Usage
We assume you have some working knowledge of Terraform to consume this module.
```HCL
module "masq_node" {
  source            = "github.com/MASQ-Project/terraform-vultr-masq-server?ref=v0.0.7"
  API_KEY           = "********* Vultr API Key *********"
  downloadurl       = "http://download.location/masq.zip"
  customnNighbors   = "MASQ Nighbors ID"
  mnemonic_list     = [ "mnemonic phrase" ]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements
No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vultr"></a> [vultr](#provider\_vultr) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_API_KEY"></a> [API\_KEY](#input\_API_\KEY) | API Key for Vultr. | `string` | `""` | Yes |
| <a name="input_vultr_plan"></a> [vultr\_plan](#input\_vultr\_plan) | Vultr Plan ID: https://www.vultr.com/api/#tag/plans | `string` | `""` | no |
| <a name="input_vultr_region"></a> [vultr\_region](#input\_vultr\_region) | Vultr Region ID: https://www.vultr.com/api/#operation/list-regions | `string` | `""` | no |
| <a name="input_vultr_os"></a> [vultr\_os](#input\_vultr\_os) | Vultr OS ID: https://www.vultr.com/api/#operation/list-os | `string` | `""` | no |
| <a name="input_bcsurl"></a> [bcsurl](#input\_bcsurl) | The url of the blockchain service.  This defaults to ropsten url. | `string` | `"https://ropsten.infura.io/v3/0ead23143b174f6983c76f69ddcf4026"` | no |
| <a name="input_centralLogging"></a> [centralLogging](#input\_centralLogging) | Would you like to enable central logging via cloudwatch logs. | `bool` | `false` | no |
| <a name="input_chain"></a> [chain](#input\_chain) | The name of the blockchain to use, mainnet and ropsten are the only valid options. | `string` | `"ropsten"` | no |
| <a name="input_clandestine_port"></a> [clandestine\_port](#input\_clandestine\_port) | This is the port you want MASQ to listen on for clandestine traffic.  This will be used for your config.toml and SG settings. | `number` | `null` | no |
| <a name="input_conkey"></a> [conkey](#input\_conkey) | The private key to sign consuming transactions. | `string` | `""` | no |
| <a name="input_dbpass"></a> [dbpass](#input\_dbpass) | The password you would like to use for the MASQ DB. | `string` | `"Whynotchangeme123"` | no |
| <a name="input_dnsservers"></a> [dnsservers](#input\_dnsservers) | The DNS servers to use to resolve URLs for requests. | `string` | `"1.0.0.1,1.1.1.1,8.8.8.8,9.9.9.9"` | no |
| <a name="input_gasprice"></a> [gasprice](#input\_gasprice) | The gas price you are willing to pay to settle transactions. | `number` | `50` | no |
| <a name="input_loglevel"></a> [loglevel](#input\_loglevel) | MASQNode Log Level - [off, error, warn, info, debug, trace] | `string` | `"trace"` | no |
| <a name="input_paymentThresholds"></a> [paymentThresholds](#input\_paymentThresholds) | These are parameters that define thresholds to determine when and how much to pay other Nodes for routing "1000000000\|1200\|1200\|500000000\|21600\|500000000" | `string` | `""` | no |
| <a name="input_ratePack"></a> [ratePack](#input\_ratePack) | These four parameters specify your rates that your Node will use for charging other Nodes for your provided services "1\|10\|2\|20"  | `string` | `""` | no |
| <a name="input_scanIntervals"></a> [scanIntervals](#input\_scanIntervals) | These three intervals describe the length of three different scan cycles running "600\|600\|600" | `string` | `""` | no |
| <a name="input_customnNighbors"></a> [customnNighbors](#input\_customnNighbors) | Node Descriptors for connecting to the MASQ network. Separate with a ','. | `string` | `""` | no |
| <a name="input_centralNighbors"></a> [centralNighbors](#input\_centralNighbors) | Gets official MASQ Node Descriptors. [customnNighbors](#input\_customnNighbors) will be ignored | `bool` | `false` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create. | `number` | `1` | no |
| <a name="input_mnemonic_list"></a> [mnemonic\_list](#input\_mnemonic\_list) | List of mnemonic. | `list` | `[""]` | yes |
| <a name="input_earnwallet_list"></a> [earnwallet\_list](#input\_earnwallet\_list) | List of earnwallets. | `list` | `[""]` | no |
| <a name="input_downloadurl"></a> [downloadurl](#input\_downloadurl) | URL of MASQ bin file, .zip formatt. | `string` | `""` | yes |
| <a name="input_pushDescriptor"></a> [pushDescriptor](#input\_pushDescriptor) | POST's Nodes Descriptor to Cloud_List API | `bool` | `false` | no |
| <a name="input_masterNode"></a> [masterNode](#input\_masterNode) | Use this to set Node as Master. | `bool` | `false` | no |
| <a name="input_cycleDerivation"></a> [cycleDerivation](#input\_cycleDerivation) | Cycles Wallet Derivation path by 1 for each node Created. | `bool` | `false` | no |
| <a name="input_derivationIndex"></a> [derivationIndex](#input\_derivationIndex) | Sets Derivation Index Start. | `number` | `0` | no |
| <a name="input_sshKey"></a> [sshKey](#input\_sshKey) | SSH Pub Key | `string` | `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbz5Xvn3cBuM1YuwFjI90gNJy0M/6XUXL/D5vFscxYk` | no |
| <a name="input_sshKeyName"></a> [sshKeyName](#input\_sshKeyName) | SSH Pub Key Name | `string` | `keyName` | no |
| <a name="input_randomNighbors"></a> [randomNighbors](#input\_randomNighbors) | Will pull a random Nighbor from NodeFinder | `bool` | `false` | no |


## Outputs

| Name | Description |
|------|-------------|
#TODO|
<!-- END_TF_DOCS -->