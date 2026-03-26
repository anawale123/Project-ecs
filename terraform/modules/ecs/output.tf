
# ECS CLUSTER OUTPUT VARIABLE NAME 
output "ecs_cluster_name" {
 
    value           = aws_ecs_cluster.umami_app.name
    description     = "ecs cluster" 
}

# ECS SERVICE OUTPUT VARIABLE
output "service" {
    value           = aws_ecs_service.umami-service.name
    description     = "ecs service output variable"

}

# ECS CLUSTER OUTPUT VARIABLE
 output "cluster" {
    value          = aws_ecs_cluster.umami_app.name
    description    = "cluster output variable"
 }