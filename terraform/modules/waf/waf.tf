# WAF ACL
resource "aws_wafv2_web_acl" "staging_waf" {
  name        = "staging-waf"
  description = "WAF for staging ALB"
  scope       = "REGIONAL" 

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "staging-waf"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "common-rule-set"
      sampled_requests_enabled   = true
    }
  }
  tags = {
    Environment = var.environment
  }
}

# WAF association with ALB
resource "aws_wafv2_web_acl_association" "staging_waf_assoc" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.staging_waf.arn
}





