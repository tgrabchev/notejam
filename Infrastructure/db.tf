#Generating random string password for the DB Instance
resource "random_string" "db_password" {
    length = 16
    special = false
}

#Creating 1 MySQL DB Instances 
resource "aws_db_instance" "notejam_db" {
  count = 1
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.id
  engine                 = "mysql"
  engine_version         = "8.0.20"
  instance_class         = "db.t2.micro"
  multi_az               = true
  db_name                = "mydb"
  username               = "username"
  password               = random_string.db_password.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
}

#Creating SSM Parameter to store the DB password as secure string
resource "aws_ssm_parameter" "db_ssm_password" {
    name = "db_ssm_password"
    type = "SecureString"
    value = random_string.db_password.result

}

#Creating the DB Subnet Group
resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "main"
  subnet_ids = [aws_subnet.database-subnet-1.id, aws_subnet.database-subnet-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# Create Database Security Group
resource "aws_security_group" "database-sg" {
  name        = "Database-SG"
  description = "Allow inbound traffic from application layer"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.custom-instance-sg.id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database-SG"
  }
}