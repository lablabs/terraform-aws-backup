# terraform apply --target aws_dynamodb_table.basic-dynamodb-table
resource "aws_dynamodb_table" "basic-dynamodb-table" {
  #checkov:skip=CKV_AWS_28
  #checkov:skip=CKV_AWS_119
  #checkov:skip=CKV2_AWS_16
  #checkov:skip=CKV_AWS_28


  provider       = aws.source
  name           = "TestAWSBackup"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "UserId"
  range_key      = "Title"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Title"
    type = "S"
  }

  tags = {
    Name        = "TestAWSBackup"
    Environment = "Dev"
  }
}
