variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "shahzaib-eks-cluster"
}

variable "node_instance_type" {
  default = "t3.micro"   
}

variable "desired_nodes" {
  default = 1
}

variable "max_nodes" {
  default = 2
}

variable "min_nodes" {
  default = 1
}
