
output "appsync_api_endpoint" {
  description = "The API endpoint URL for the AppSync API"
  value       = aws_appsync_graphql_api.appsync.uris["GRAPHQL"]
}