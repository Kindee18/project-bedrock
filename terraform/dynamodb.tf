resource "aws_dynamodb_table" "carts" {
  name           = "Items"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Project = "Bedrock"
  }
}
