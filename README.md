## Description
This module's purpose is to automatically deploy an VM to Vultr and have it configure itself to be a node in the MASQ Network (masq.ai)

## Usage
We assume you have some working knowledge of Terraform to consume this module.
```HCL
module "masq_node" {
  source            = "github.com/MASQ-Project/terraform-vultr-masq-server?ref=v0.0.1"
  API_KEY           = "********* Vultr API Key *********"
  downloadurl       = "http://download.location/masq.zip"
  customnNighbors   = "MASQ Nighbors ID"
  mnemonic_list     = [ 
    "Test Workds One Two Thhee" 
    ]
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
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the SSH Key Pair you want to use. | `string` | `""` | no |
| <a name="input_customnNighbors"></a> [customnNighbors](#input\_customnNighbors) | Node Descriptors for connecting to the MASQ network. Separate with a ','. | `string` | `""` | no |
| <a name="input_centralNighbors"></a> [centralNighbors](#input\_centralNighbors) | Gets official MASQ Node Descriptors. | `bool` | `false` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create. | `number` | `1` | no |
| <a name="input_mnemonic_list"></a> [mnemonic\_list](#input\_mnemonic\_list) | List of mnemonic. | `list` | `[""]` | yes |
| <a name="input_earnwallet_list"></a> [earnwallet\_list](#input\_earnwallet\_list) | List of earnwallets. | `list` | `[""]` | no |
| <a name="input_downloadurl"></a> [downloadurl](#input\_downloadurl) | URL of MASQ bin file, .zip formatt. | `string` | `""` | yes |






## Outputs

| Name | Description |
|------|-------------|
#TODO|
<!-- END_TF_DOCS -->