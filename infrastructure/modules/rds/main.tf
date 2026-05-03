# -------------------
# Random Password (secure)
# -------------------
resource "random_password" "db" {
  length  = 16
  special = true
}

# -------------------
# Secrets Manager
# -------------------
resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.project_name}-db-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
  })
}

# -------------------
# Read Secret
# -------------------
locals {
  db_creds = jsondecode(
    aws_secretsmanager_secret_version.db_secret_version.secret_string
  )
}

# -------------------
# Security Group
# -------------------
resource "aws_security_group" "rds_sg" {
  name   = "${var.project_name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "PostgreSQL access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------
# Subnet Group
# -------------------
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# -------------------
# RDS Instance
# -------------------
resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-db"

  engine         = "postgres"
  engine_version = "15"
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage

  db_name  = var.db_name
  username = local.db_creds.username
  password = local.db_creds.password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "${var.project_name}-rds"
  }
}