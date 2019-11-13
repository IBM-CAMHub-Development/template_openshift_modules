output "dependsOn" { 
	value = "${null_resource.ign_config_generated.id}" 
	description="Output Parameter when Module Complete"
}

output "bootstrap_ign"{
  depends_on = ["camc_scriptpackage.get_bootstrap_ign"]
  value = "${camc_scriptpackage.get_bootstrap_ign.result["stdout"]}"
  description="Base64 encoded bootstrap ign"
} 

output "bootstrap_sec_ign"{
  depends_on = ["camc_scriptpackage.get_bootstrap_sec_ign"]
  value = "${camc_scriptpackage.get_bootstrap_sec_ign.result["stdout"]}"
  description="Base64 encoded bootstrap url ign"
} 

output "master_ign"{
  depends_on = ["camc_scriptpackage.get_master_ign"]
  value = "${camc_scriptpackage.get_master_ign.result["stdout"]}"
  description="Base64 encoded master ign"
} 

output "worker_ign"{
  depends_on = ["camc_scriptpackage.get_worker_ign"]
  value = "${camc_scriptpackage.get_worker_ign.result["stdout"]}"
  description="Base64 encoded worker ign"
} 
