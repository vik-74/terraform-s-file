# Create Database Subnet Group
# terraform aws db subnet group
resource "aws_db-subnet_group" "database-subnet-group" {
  name        = "database subnets"
  subnet_ids  = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
  description = "Subnet for database Instance"

  tags = {
    Name = "Database Subnets"
  }
}


# Create the Latest DB Snapshot
# terraform aws data db snapshot

data "aws_db_snapshot" "l-db-snapshot" {

  db_instance_identifier = var.database-snapshot-identifier
  most_recent            = true
  snapshot_type          = "manuel"

}


# Create Database Instance Restored from DB Snapshot
# terraform aws db instance
resource "aws_db_instance" "database-instance" {
  instance_class         = database-instance-class
  availability_zone      = "us-east-1a"
  skip_final_snapshot    = true
  identifier             = var.database-instance-identifier
  snapshot_identifier    = data.aws_db_snapshot.l-db-snapshot
  db_subnet_group_name   = aws_db-subnet_group.database-subnet-group.name
  multi_az               = var.multi_az-deployment
  vpc_security_group_ids = [aws_security_group.database-security-group.id]

}


