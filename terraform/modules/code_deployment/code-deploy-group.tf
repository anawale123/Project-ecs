resource "aws_codedeploy_deployment_group" "ecs" {
  app_name              = aws_codedeploy_app.ecs.name
  deployment_group_name = "ecs-blue-green"
  service_role_arn      = var.codedeploy_role_arn

  ecs_service {
  cluster_name = var.cluster_name
  service_name = var.service_name
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.alb_listener
      }

      target_group {
        name = var.blue_tg
      }

      target_group {
        name = var.green_tg
      }
    }
  }
}
