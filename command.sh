
#==================== 2. declare AWS_Region =========================#
AWS_REGION=ap-southeast-1

#==================== 3. deploy step =========================#
AWS_PROFILE=user-ecs copilot svc deploy --name svc-nestjs-ecs-api --env dev