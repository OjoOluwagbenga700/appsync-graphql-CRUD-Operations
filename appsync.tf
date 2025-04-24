
# Create AppSync API
resource "aws_appsync_graphql_api" "appsync" {
  name                = var.appsync_api_name
  authentication_type = "API_KEY"
  # Add schema definition
  schema = file("schema.graphql")

}

# Create API Key
resource "aws_appsync_api_key" "key" {
  api_id = aws_appsync_graphql_api.appsync.id

}

# Create DynamoDB data source
resource "aws_appsync_datasource" "dynamodb" {
  api_id           = aws_appsync_graphql_api.appsync.id
  name             = "dynamodb_datasource"
  service_role_arn = aws_iam_role.appsync_role.arn
  type             = "AMAZON_DYNAMODB"

  dynamodb_config {
    table_name = aws_dynamodb_table.inventory_table.name
  }

  depends_on = [aws_iam_role.appsync_role, aws_dynamodb_table.inventory_table]
}


# Create resolver for Query field
resource "aws_appsync_resolver" "getItem_query" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Query"
  field       = "getItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template  = file("${path.module}/resolvers/Query/getItem/request.vtl")
  response_template = file("${path.module}/resolvers/Query/getItem/response.vtl")
}


resource "aws_appsync_resolver" "listItems_query" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Query"
  field       = "listItems"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template  = file("${path.module}/resolvers/Query/listItems/request.vtl")
  response_template = file("${path.module}/resolvers/Query/listItems/response.vtl")
}



# Create resolver for Mutation field
resource "aws_appsync_resolver" "mutation" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Mutation"
  field       = "createItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template  = file("${path.module}/resolvers/Mutations/createItems/request.vtl")
  response_template = file("${path.module}/resolvers/Mutations/createItems/response.vtl")
}

# Create resolver for Update operation
resource "aws_appsync_resolver" "update_mutation" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Mutation"
  field       = "updateItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template  = file("${path.module}/resolvers/Mutations/updateItems/request.vtl")
  response_template = file("${path.module}/resolvers/Mutations/updateItems/response.vtl")
}

# Create resolver for Delete operation  
resource "aws_appsync_resolver" "delete_mutation" {
  api_id      = aws_appsync_graphql_api.appsync.id
  type        = "Mutation"
  field       = "deleteItem"
  data_source = aws_appsync_datasource.dynamodb.name

  request_template  = file("${path.module}/resolvers/Mutations/deleteItems/request.vtl")
  response_template = file("${path.module}/resolvers/Mutations/deleteItems/response.vtl")
}



