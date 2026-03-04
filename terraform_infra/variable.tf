variable "keys" {
  type      = list(string)
  default   = ["", ""]
  sensitive = true
}

variable "aws_region" {
  type = string
}