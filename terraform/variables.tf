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
  default     = "Assignment1"
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
    "Prod"    = "t2.micro"
    "Dev"     = "t2.micro"
    "Staging" = "t2.micro"
  }
  type        = map(string)
  description = "Type of EC2 instance"
}

#variable to declare keyname
variable "keyName" {
  default     = "assignment1"
  type        = string
  description = "SSH key pair's name"
}