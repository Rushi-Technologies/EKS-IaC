variable "aws_region" {
  type = string
  default = "ap-south-1"
  description = "AWS Region to create all resources"  
}

variable "vpc_name" {
  type = string
  default = "eks-lic-vpc"
  description = "Name of the VPC to be created" 
}

variable "vpc_cidr" {
  type = string
  default = ""
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = []
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = []
  description = "List of CIDR blocks for private subnets"   
  
}
variable "public_subnet_tags" {
  type = map(string)
  default = {}
  description = "Tags to be applied to public subnets"
}
variable "private_subnet_tags" {
  type = map(string)
  default = {}
  description = "Tags to be applied to private subnets"
}

variable "tags" {
  type = map(string)
  default = {
    Owner       = "Rushi Technologies"
    Environment = "Dev"
    Project     = "EKS-LIC"
    CostCenter  = "IT"
  }
  description = "Tags to be applied to all resources"
}

variable "project_name" {
  type = string
  default = "eks-lic"
  description = "Project Name"
}
variable "environment" {
  type = string
  default = "dev"
  description = "Environment Name"
}

variable "cluster_name" {
  type = string
  default = "eks-lic-cluster"
  description = "EKS Cluster Name"
}


variable "eks_cluster_role_name" {
    description = "The name of the IAM role for the EKS cluster"
    type        = string
    default     = "lic-eks-cluster-role"
}

variable "endpoint_private_access" {
  description = "Enable private access to the EKS API server"
  type        = bool
  default     = true     
}

variable "endpoint_public_access" {
  description = "Enable public access to the EKS API server"
  type        = bool
  default     = true     
}

variable "eks_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.33"
}

variable "eks_worker_role_policy_arns" {
  description = "List of IAM policy ARNs to attach to the EKS worker role"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  ]
}

variable "node_group_disk_size" {
  description = "Disk size for the EKS node group"
  type        = number
  default     = 20
}

variable "node_group_desired_size" {
  description = "Desired size for the EKS node group"
  type        = number
  default     = 2
}
variable "node_group_min_size" {
  description = "Minimum size for the EKS node group"
  type        = number
  default     = 1    
}
variable "node_group_max_size" {
  description = "Maximum size for the EKS node group"
  type        = number
  default     = 3     
}

variable "node_group_instance_type" {
  description = " Instance type for the EKS node group"
  type        = string
  default     = "t3.small"
}