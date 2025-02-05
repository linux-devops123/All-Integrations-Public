#input variables

variable "availability_zone"{
    type = string
}

variable "instance_type"{
    type = string
}

variable "key_name"{
    type = string
}
variable "ami_id"{
    type = string
}
variable "security_group_id"{
    type = string
}
variable "count_val"{
    type = number
}
variable "instance_tags"{
    type = object({
        Name = string,
        Environment= string,
        Owner = string
    })
}