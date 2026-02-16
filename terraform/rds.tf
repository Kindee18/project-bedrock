
resource "aws_security_group" "rds" {
  name_prefix = "bedrock-rds-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  tags = {
    Project = "Bedrock"
  }
}

resource "aws_db_subnet_group" "bedrock" {
  name       = "bedrock-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Project = "Bedrock"
  }
}

resource "aws_db_instance" "catalog" {
  identifier        = "bedrock-catalog"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  db_name           = "catalog"
  username          = "adminuser"
  password          = "SuperSecretPass123!" # In prod, use random_password or Secrets Manager
  db_subnet_group_name = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Project = "Bedrock"
  }
}

resource "aws_db_instance" "orders" {
  identifier        = "bedrock-orders"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "16.3" # Verified supported version
  instance_class    = "db.t3.micro"
  db_name           = "orders"
  username          = "adminuser"
  password          = "SuperSecretPass123!"
  db_subnet_group_name = aws_db_subnet_group.bedrock.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Project = "Bedrock"
  }
}
