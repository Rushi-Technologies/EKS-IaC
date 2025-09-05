locals {
  nameprefix = "${var.project_name}-${var.environment}"
  cluster_name = "${var.cluster_name}-${var.environment}"  
  public_subent_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
  }
   privagte_subnet_tags = {
    "kubernetes.io/role/internal-elbelb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
  }
}