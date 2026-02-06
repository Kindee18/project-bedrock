resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Project = "Bedrock"
  }
}

# AWS Console Access: ReadOnlyAccess
resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create Access Keys (Required for submission)
resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}
