# This implements some crude scaling for our ECS services.
#
# If this is a non-critical service, this creates two scheduled events
# in Amazon EventBridge:
#
#   - Every weekday evening, set the DesiredTaskCount to 0 (turning it off)
#   - Every weekday morning, set the DesiredTaskCount to the desired value
#     (turning it on)
#
# This is only meant for persistently-running services -- anything which
# uses autoscaling should already be turning itself off when not in use.
#
# For an explanation of how this code works, see https://alexwlchan.net/2023/bedtime-for-ecs/

resource "aws_iam_role" "scheduler" {
  count = var.turn_off_outside_office_hours ? 1 : 0

  name               = "${var.service_name}-office-hours-scaling"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "allow_update_service" {
  statement {
    actions = [
      "ecs:UpdateService",
    ]

    resources = [
      aws_ecs_service.service.id,
    ]
  }
}

resource "aws_iam_role_policy" "allow_update_service" {
  count = var.turn_off_outside_office_hours ? 1 : 0

  role   = aws_iam_role.scheduler[0].name
  policy = data.aws_iam_policy_document.allow_update_service.json
}

resource "aws_scheduler_schedule" "turn_on_in_the_morning" {
  count = var.turn_off_outside_office_hours ? 1 : 0

  name       = "${var.service_name}-turn_on_in_the_morning"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  # This cron expression will run at 7am UTC on weekdays.
  #
  # This ensures it will always be up and running by 9am in London,
  # allowing for a bit of slop and timezone offsets.
  schedule_expression = "cron(0 7 ? * MON,TUE,WED,THUR,FRI *)"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.scheduler[0].arn

    input = jsonencode({
      Cluster      = var.cluster_arn
      Service      = aws_ecs_service.service.name
      DesiredCount = var.desired_task_count
    })
  }
}

resource "aws_scheduler_schedule" "turn_off_in_the_evening" {
  count = var.turn_off_outside_office_hours ? 1 : 0

  name       = "${var.service_name}-turn_off_in_the_evening"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  # This cron expression will run at 7pm UTC on weekdays.
  schedule_expression = "cron(0 19 ? * MON,TUE,WED,THUR,FRI *)"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ecs:updateService"
    role_arn = aws_iam_role.scheduler[0].arn

    input = jsonencode({
      Cluster      = var.cluster_arn
      Service      = aws_ecs_service.service.name
      DesiredCount = 0
    })
  }
}
