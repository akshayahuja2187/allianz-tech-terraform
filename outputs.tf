output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins.ip_address
}

output "jenkins_admin_username" {
  value = azurerm_jenkins_server.jenkins.admin_username
}

output "jenkins_admin_password" {
  value = azurerm_jenkins_server.jenkins.admin_password
}