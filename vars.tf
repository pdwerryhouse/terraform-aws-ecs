variable "name"               { }
variable "env"                { }
variable "desired_capacity"   { default = "0" }
variable "instance_type"      { }
variable "max_size"           { default = "0" }
variable "min_size"           { default = "0" }
variable "ssh_key_name"       { }
variable "subnets"            { }
variable "user_data"          { }
variable "volume_type"        { default = "gp2" }
variable "volume_size"        { default = "20" }
variable "vpc_id"             { }

variable "container_definitions" { }
