variable "image_name" {
  description = "Environment"
  type        = string
  default = "nginx:latest"
}

resource "docker_image" "nginx" {
  name         = var.image_name
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8001
  }
}
