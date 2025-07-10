source_region             = "ca-central-1"
destination_region        = "us-west-2"

primary_vpc_cidr          = "10.0.0.0/16"
primary_public_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
primary_private_subnets   = ["10.0.11.0/24", "10.0.12.0/24"]
primary_azs               = ["ca-central-1a", "ca-central-1b"]

secondary_vpc_cidr        = "10.1.0.0/16"
secondary_public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
secondary_private_subnets = ["10.1.11.0/24", "10.1.12.0/24"]
secondary_azs             = ["us-west-2a", "us-west-2b"]

enable_nat_gateway        = true

source_bucket_name        = "my-source-bucket"
destination_bucket_name   = "my-destination-bucket"

instance_type             = "t3.micro"
instance_ami_source       = "ami-0bb887e1f2559badd"
instance_ami_destination  = "ami-040361ed8686a66a2"

allocated_storage         = 20
backup_retention_days     = 7
engine                    = "mysql"
engine_version            = "8.0"
instance_class            = "db.t3.micro"
master_username           = "admin"
master_password           = "YourSecurePassword123!"
source_db_identifier      = "source-db"
destination_db_identifier = "destination-db"
backup_window             = "03:00-04:00"

max_size                  = 2
min_size                  = 1
desired_capacity          = 1
health_check_path         = "/"
