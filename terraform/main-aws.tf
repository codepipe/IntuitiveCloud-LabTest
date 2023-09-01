# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Update with your desired AWS region
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.150.0.0/20"
}

# Create an internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create public and private subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.150.0.0/24" # Adjust the CIDR block as needed
  availability_zone       = "us-east-1a"   # Adjust the availability zone as needed
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.150.1.0/24" # Adjust the CIDR block as needed
  availability_zone       = "us-east-1b"   # Adjust the availability zone as needed
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.150.2.0/24" # Adjust the CIDR block as needed
  availability_zone       = "us-east-1c"   # Adjust the availability zone as needed
}

# Create a security group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"

  # Define inbound and outbound rules as needed
  # For example, allow SSH traffic:
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances in the public subnet
resource "aws_instance" "public_ec2" {
  count         = 2
  ami           = "ami-xxxxxxxxxxxxxxxxx" # Replace with the desired AMI ID
  instance_type = "t2.micro"              # Adjust the instance type as needed
  subnet_id     = aws_subnet.public_subnet.id

  # Attach a 100 GB EBS volume to each instance
  root_block_device {
    volume_size = 100
  }

  # Attach the security group to the instances
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

# Create an S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "your-unique-bucket-name" # Replace with your desired bucket name
  acl    = "private"                 # Adjust the ACL as needed
}

# Attach a policy to the S3 bucket to allow read access from EC2 instances
resource "aws_s3_bucket_policy" "example_bucket_policy" {
  bucket = aws_s3_bucket.example_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = ["s3:GetObject"],
        Effect = "Allow",
        Resource = aws_s3_bucket.example_bucket.arn,
        Principal = {
          AWS = "*"
        }
      }
    ]
  })
}

