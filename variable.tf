variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "us-east-1"

}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "dynamodb_table"

}

variable "appsync_api_name" {
  description = "The name of the AppSync API."
  type        = string
  default     = "appsync_api"

}