resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = "High-CPU"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Trigger if CPU > 80% for 4 minutes"
  alarm_actions             = []
  dimensions = {
    InstanceId = aws_instance.app.id
  }
}
