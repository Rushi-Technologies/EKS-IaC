module "vpc" {
  source = "git::https://github.com/Rushi-Technologies/VPC.git"
  name   = var.vpc_name
  cidr_block   = var.vpc_cidr
  public_subnets_azs =   data.aws_availability_zones.available.names[*]
  private_subnets_azs =  data.aws_availability_zones.available.names[*]
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  create_nat_gateway = true
  public_subnet_tags = local.public_subent_tags
  private_subnet_tags = local.privagte_subnet_tags
  tags = var.tags 
}

resource "aws_iam_role" "cluster" {
  name = var.eks_cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_cluster.json
  tags = merge(var.tags, { "Name" = "${local.nameprefix}-eks-cluster-role" })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_cluster" "main" {

  name     = local.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version = var.eks_version

  vpc_config {
    subnet_ids = flatten([module.vpc.public_subnet_ids,module.vpc.private_subnet_ids])
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access 
  }
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  depends_on = [ aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy]
  tags = merge(var.tags, { "Name" = "${local.nameprefix}-eks-cluster" })

}


resource "aws_iam_role" "worker" {
  name = "${local.cluster_name}-worker-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_worker.json
  tags = merge(var.tags, { "Name" = "${local.nameprefix}-eks-worker-role" })
}

resource "aws_iam_role_policy_attachment" "worker_role_policy_attachment" {
  for_each = toset(var.eks_worker_role_policy_arns)
  policy_arn = each.value
  role       = aws_iam_role.worker.name
}
resource "aws_eks_node_group" "main" {
    
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${local.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = module.vpc.private_subnet_ids
  capacity_type = "ON_DEMAND"
  disk_size = var.node_group_disk_size
  instance_types = [var.node_group_instance_type]
  ami_type = "BOTTLEROCKET_x86_64"

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = merge(var.tags, { "Name" = "${local.nameprefix}-eks-node-group" })  
}