variable "dns_server_ip"        { type = "string"  description = "IP address of the server where DNS will be configured" }
variable "vm_os_user"           { type = "string"  description = "Operating System user for the Operating System User to access virtual machine"}
variable "vm_os_password"       { type = "string"  description = "Operating System Password for the Operating System User to access virtual machine"}
variable "private_key"          { default = ""     type = "string"  description = "Private SSH key Details to the Virtual machine"}

variable "action"               { default = ""     type = "string"  description = "Indicates the configuration action to be taken (setup, addMaster, addWorker)" }
variable "domain_name"          { default = ""     type = "string"  description = "Name of the base domain for the cluster" }
variable "cluster_name"         { default = ""     type = "string"  description = "Name of the cluster" }
variable "cluster_ip"           { default = ""     type = "string"  description = "IP address of the cluster" }
variable "node_ips"             { default = []     type = "list"    description = "IP address(es) of the node(s) within the cluster" }
variable "node_names"           { default = []     type = "list"    description = "Name(s) of the node(s) within the cluster" }
variable "dependsOn"            { default = "true"                  description = "Boolean for dependency"}