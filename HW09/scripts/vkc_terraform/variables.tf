variable "vkcs_username" {
  type        = string
  description = "VKCS username"
  sensitive   = true
}

variable "vkcs_password" {
  type        = string
  description = "VKCS password"
  sensitive   = true
}

variable "vkcs_project_id" {
  type        = string
  description = "VKCS project ID"
  sensitive   = true
}
