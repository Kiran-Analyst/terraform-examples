variable "names" {
    type = set(string)
    default = []
}

variable "project_id" {
    type = string
    default = ""
}

variable "prefix" {
    type = string
    default = ""
}

variable "location" {
    type = string
    default = "us-east1"
}


