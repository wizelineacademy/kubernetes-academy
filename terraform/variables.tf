variable "project_id" {
  description = "The K8s Academy GCP project id."
  type        = string
  default     = "wizeline-academy-k8s-36bd66a7"
}

variable "region" {
  description = "Which GCP region to place the K8s cluster in."
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name of the VPC to create for the cluster."
  type        = string
  default     = "academy-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet to create on the VPC for the cluster."
  type        = string
  default     = "academy-subnet"
}

variable "subnet_cidr_range" {
  description = "IP range for the VPC subnet in CIDR notation."
  type        = string
  default     = "10.2.0.0/16"
}

variable "pods_range_name" {
  description = "Name of the IP range to create for the k8s pods."
  type        = string
  default     = "academy-subnet-range-pods"
}

variable "services_range_name" {
  description = "Name of the IP range to create for the k8s services."
  type        = string
  default     = "academy-subnet-range-services"
}

variable "pods_cidr_range" {
  description = "IP range for k8s pods in CIDR notation."
  type        = string
  default     = "172.16.24.0/22"
}

variable "services_cidr_range" {
  description = "IP range for k8s services in CIDR notation."
  type        = string
  default     = "172.16.28.0/22"
}

variable "academy_google_group" {
  description = "Email address of the Google group to give access to."
  type        = string
  default     = "kubernetes-academy@wizeline.com"
}