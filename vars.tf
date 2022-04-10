#### EKS ####
variable "cluster_name" {
  type = string
  default = "telio_ev"
}

variable "subnet_ids" {
  type = list(string)
  default = ["subnet-078efc8ec4f1b0aa5,subnet-09409d159eec54fc1"]
}

#### EKS_Nodes ####
variable "worker_name" {
  default = "telio_ev_worker"
}

variable "desired_size" {
  type = number
  default = 2
}

variable "max_size" {
  type = number
  default = 2
}

variable "min_size" {
  type = number
  default = 1
}

variable "ami_type" {
  type = string
  default = "ami-04505e74c0741db8d"
}

variable "instance_types" {
  type = string
  default = "t2.micro"
}