variable "owner" {
  description = "the name of owner"
  type        = string
  default     = "ziv"
}

variable "instance_type" {
  description = "the size of ec2 insatnces to run (e.g. t2.micro)"
  type        = string
  default     = "t2.medium"

}

variable "key_name" {
  description = "the name of key to connect ec2 via ssh"
  type        = string
  default     = "Ziv_Zhang_Virginia"
}

variable "azs" {
  description = "the region and zones of aws"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "key_pair_file" {
  description = "the name of key pair file"
  type = string
  default = "ziv"
  
}