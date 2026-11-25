variable "image" {
  description = "App image"
  type        = string
  default     = "ghcr.io/yucheng724/sre-lab:latest"
}

variable "replicas" {
  type    = number
  default = 3
}
