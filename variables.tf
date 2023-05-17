variable "region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "my-project"
}

variable "project_env" {
  default = "prod"
}

variable "ami_id" {

  description = "ami id of amazon linux"
  type        = string
  default     = "ami-0c768662cc797cd75"

}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"

}

variable "domain_name" {
  default = "ashna.online"
}

variable "record_name" {
  default = "blog"
}
