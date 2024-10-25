# Default Tags
variable "defaultTags" {
  default = {
    "Owner" = "Hongwei"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Prefix to identify resources
variable "prefix" {
  default     = "Assignment2"
  type        = string
  description = "Name prefix"
}

# variable to signal the current environment
variable "env" {
  default     = "Prod"
  type        = string
  description = "Production Environment"
}

# Instance Type
variable "instanceType" {
  default = {
    "Prod"    = "t3.small"
    "Dev"     = "t3.small"
    "Staging" = "t3.small"
  }
  type        = map(string)
  description = "Type of EC2 instance"
}

#variable to declare keyname
variable "keyName" {
  default     = "a2"
  type        = string
  description = "SSH key pair's name"
}