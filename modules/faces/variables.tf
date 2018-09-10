variable "faces_amis" {
  type        = "map"
  description = "map of region to ami for faces nodes"

  default = {
    "us-east-1"      = "ami-029b3fc1a877d2604"
    "us-east-2"      = "ami-0576b5118fe0660ed"
    "us-west-2"      = "ami-0b4943b7d0bd643b3"
    "ap-southeast-2" = "ami-0cd34e9692b5453e2"
    "eu-west-1"      = "ami-0e3167396f7fd1c2d"
  }
}

variable "faces_iam_role_name" {
  type        = "string"
  description = "The name of the IAM role that will be applied to faces roles. Must be created by the facesiam module"
}

variable "faces_instance_type" {
  type        = "string"
  description = "instance type for servers"
}

variable "faces_max_cluster_size" {
  type        = "string"
  description = "The max number of faces server nodes to spin up"
}

variable "faces_min_cluster_size" {
  type        = "string"
  description = "The max number of faces server nodes to spin up"
}

variable "faces_subnet_id_1" {
  type        = "string"
  description = "The first subnet ID to use to deploy the faces cluster into. Needs to be in a different AZ than faces_subnet_id_2"
}

variable "faces_subnet_id_2" {
  type        = "string"
  description = "The second subnet ID to use to deploy the faces cluster into. Needs to be in a different AZ than faces_subnet_id_1"
}

variable "faces_user_init" {
  type        = "string"
  description = "Custom cloud-init that is rendered to be used on faces instances. (Not Recommened)"
  default     = ""
}

variable "faces_volume_size" {
  type        = "string"
  description = "The OS disk size for Faces Server"
  default     = "50"
}

variable "key_name" {
  type        = "string"
  description = "The name of the SSH key to use"
}

variable "log_retention" {
  type        = "string"
  description = "Optional. The log retention for cloudwatch logs.  Default 7 days"
  default     = "7"
}

variable "platform_instance_id" {
  type        = "string"
  description = "A human-readable string for this instance of the GrayMeta Platform"
}

variable "rds_allocated_storage" {
  type        = "string"
  description = "Number of GB to allocate for RDS faces instance"
  default     = "100"
}

variable "rds_backup_retention" {
  type        = "string"
  description = "RDS backup retention"
  default     = "7"
}

variable "rds_backup_window" {
  type        = "string"
  description = "RDS Backup window"
  default     = "03:00-04:00"
}

variable "rds_db_instance_size" {
  type        = "string"
  description = "The size of the instance to use for the RDS database instance"
  default     = "db.t2.small"
}

variable "rds_db_password" {
  type        = "string"
  description = "password for postgresql database"
}

variable "rds_db_username" {
  type        = "string"
  description = "username for postgresql database"
}

variable "rds_multi_az" {
  type        = "string"
  description = "Multizone setting in RDS.  Default is true"
  default     = true
}

variable "rds_snapshot" {
  type        = "string"
  description = "(Optional) Specify a snapshot to use on db create.  For initial install this should be empty string.  After the initial create it is recommended to set this to final."
  default     = ""
}

variable "rds_subnet_id_1" {
  type        = "string"
  description = "The first subnet ID to use to deploy the RDS database into. Needs to be in a different AZ than rds_subnet_id_2"
}

variable "rds_subnet_id_2" {
  type        = "string"
  description = "The second subnet ID to use to deploy the RDS database into. Needs to be in a different AZ than rds_subnet_id_1"
}

variable "services_ecs_cidrs" {
  type        = "list"
  description = "List of services and ecs subnet ids"
}

variable "ssh_cidr_blocks" {
  type        = "string"
  description = "Comma delimited list of cidr blocks from which to allow access via SSH"
}
