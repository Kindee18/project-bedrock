resource "aws_iam_user" "bedrock_dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Project = "Bedrock"
  }
}

# CI/CD User (Admin Access)
resource "aws_iam_user" "bedrock_ci" {
  name = "bedrock-ci"
  tags = { Project = "Bedrock" }
}

resource "aws_iam_user_policy_attachment" "ci_admin" {
  user       = aws_iam_user.bedrock_ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_access_key" "bedrock_ci" {
  user = aws_iam_user.bedrock_ci.name
}

# Developer View User (ReadOnly Access)
resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.bedrock_dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create Access Keys (Required for submission)
resource "aws_iam_access_key" "bedrock_dev_view" {
  user = aws_iam_user.bedrock_dev_view.name
}
