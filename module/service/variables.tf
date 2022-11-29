variable "owner" {
  description = "The name of owner "
  type        = string
}

variable "instance_type" {
  description = "the size of ec2 insatnces to run (e.g. t2.micro)"
  type        = string

}


variable "azs" {
  description = "the region and zones of aws"
  type = list(string)
  
}

variable "key_pair_file" {
  description = "the name of key pair file"
  type = string
  
}