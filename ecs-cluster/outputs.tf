output "aws_ecrpublic_repository" {
    value = aws_ecrpublic_repository.hello-app
}

output "ecs_cluster" {
    value = module.ecs
}