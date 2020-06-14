variable "string_val"{
    type = string
    default = "Hello"
}

variable "numeric_val"{
    type = number
    default = "123.12"
}

variable "numeric_val_1"{
    type = number
    default = 123.12
}

output "string_out_val"{
    value = var.string_val
}

output "numeric_out_val"{
    value = var.numeric_val
}

output "numeric_out_val1"{
    value = var.numeric_val_1
}