variable "owner" {
  description = "the name of owner"
  type        = string
  default     = "ziv"
}

variable "instance_type" {
  description = "the size of ec2 insatnces to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"

}

variable "key_name" {
  description = "the name of key to connect ec2 via ssh"
  type        = string
  default     = "Ziv_Zhang_Virginia"
}