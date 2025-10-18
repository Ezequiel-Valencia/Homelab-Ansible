# resource "aws_apigatewayv2_api" "ezq_backend_backend" {
#   name          = "ProxyToExternalAPI"
#   protocol_type = "HTTP"
# }

# resource "aws_apigatewayv2_integration" "ezq_external_api" {
#     api_id = aws_apigatewayv2_api.ezq_backend_backend.id
#     integration_type = "HTTP_PROXY"
#     integration_method = "GET"
#     integration_uri = "https://backend.ezequielvalencia.com/{proxy}"
# }

# resource "aws_apigatewayv2_route" "ezq_proxy_route" {
#   api_id    = aws_apigatewayv2_api.ezq_backend_backend.id
#   route_key = "GET /{proxy+}"
#   target    = "integrations/${aws_apigatewayv2_integration.ezq_external_api.id}"
# }

# resource "aws_apigatewayv2_stage" "ezq_proxy_prod" {
#   api_id      = aws_apigatewayv2_api.ezq_backend_backend.id
#   name        = "ezq_proxy_prod"
#   auto_deploy = true
# }
