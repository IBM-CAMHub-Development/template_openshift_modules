output "dependsOn" { 
    value = "${null_resource.finish_config_inventory.id}" 
    description="Output Parameter when Module Complete"
}