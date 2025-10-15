variable "bucket_name" {
  type = string
}

variable "index_file" {
  type    = string
  default = "index.html"
}

variable "tags" {
  type = map(string)
  default = {}
}