# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create a default subnet in the first az if one does not exit
resource "aws_default_subnet" "subnet_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
}

# create a default subnet in the second az if one does not exit
resource "aws_default_subnet" "subnet_az2" {
  availability_zone = data.aws_availability_zones.available_zones.names[1]
}

# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database-subnets"
  subnet_ids  = [aws_default_subnet.subnet_az1.id, aws_default_subnet.subnet_az2.id]
  description = "Subnet for database instance"

  tags = {
    Name = "database-subnets"
  }
}


# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                 = "mysqldb"
  engine_version         = "8.0.31"
  multi_az               = false
  identifier             = "rds-instamnce"
  username               = "azvik"
  password               = "azvik123"
  instance_class         = "db.t2.micro"
  allocated_storage      = 200
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database-security-group.id]
  availability_zone      = data.aws_availability_zones.available_zones.names[0]
  db_name                = "appdb"
  skip_final_snapshot    = true
}
