terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "< 1.0.0"
        }
    }
}
provider "vkcs" {
    username   = var.vkcs_username
    password   = "sekretpassword"
    #password = var.vkcs_password
    project_id = var.vkcs_project_id
    region = "RegionOne"
    auth_url = "https://infra.mail.ru:35357/v3/" 
}


