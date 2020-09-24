resource "aws_security_group" "nfs_inbound" {
  name        = "example_nfs_inbound"
  description = "Allow traffic between services"
  vpc_id      = local.vpc_id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "TCP"

    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
}

resource "aws_security_group" "interservice" {
  name        = "example_interservice_sg"
  description = "Allow traffic between services"
  vpc_id      = local.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
}

resource "aws_security_group" "allow_full_egress" {
  name        = "example_full_egress"
  description = "Allow outbound traffic"

  vpc_id = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "load_balancer" {
  name   = "example_load_balancer"
  vpc_id = local.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
