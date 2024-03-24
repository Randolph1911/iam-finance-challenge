/*
Challenge: Parameterize IAM and S3 Resources with Variables
Objective: Modify the provided Terraform configuration to use variables for the IAM group name, S3 bucket name, and the key for an uploaded file. This will demonstrate how to create more dynamic, and reusable Terraform configurations.
Requirements:
Define Variables:
IAM group name
S3 bucket name
Key for the uploaded file
Use Variables:
Create the IAM group with a variable.
Create the S3 bucket using a variable for the bucket name.
Upload a file to the S3 bucket, using a variable for the file key.
Dynamic IAM Policy:
Use the IAM policy to dynamically refer to the S3 bucket based on the variable.
*/

variable "iam_group_name" {
  description = "Name of IAM Group:"
  type        = string
  default     = "finance-analysts"
}

variable "aws_s3_bucket_name" {
  description = "Name of S3 Bucket:"
  type        = string
  default     = "financegain-21092"
}

variable "aws_s3_object_key" {
  description = "Key for the uploaded file:"
  type        = string
  default     = "Terraform.docx"
}
