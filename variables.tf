variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to add to resources"
}

variable "sns_topic_name" {
  description = "SNS Topic Name"
  type        = string
  default     = "s3-secure-bucket-topic"
}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [8200, 8201]
}

variable "egress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = []
}
