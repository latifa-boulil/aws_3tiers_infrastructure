#################################
# EC2 POLICY, ROLE, INSTANCE ROFILE
#################################

resource "aws_iam_policy" "backend_rds_policy" {
  name = "backend-rds-policy"
  description = "Policy granted EC2 access to RDS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBSubnetGroups",
          "rds:Connect"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "backend_role" {
  name = "backend-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_policy_attach" {
  role = aws_iam_role.backend_role.name
  policy_arn = aws_iam_policy.backend_rds_policy.arn
}

resource "aws_iam_instance_profile" "backend_instance_profile" {
    name = "backend-instance-profile"
    role = aws_iam_role.backend_role.name
}

#################################
# RDS ACCESS FOR ADMIN USERS
#################################

resource "aws_iam_group" "rds_admin_access" {
    name = "rdsfull-admin"
}

resource "aws_iam_policy" "full_rds_access" {
  name        = "FullRDSAccessPolicy"
  description = "Policy granting full access to RDS resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "rds:*"  # Full RDS access
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_group_policy_attachment" "name" {
  group = aws_iam_group.rds_admin_access.name
  policy_arn = aws_iam_policy.full_rds_access.arn
}

##########################################
# 
#########################################


# iam role database ---> monitoring cloudwatch ??? 

# iam role from frontend to s3 

# iam role alb ---> s3 logs ? 

