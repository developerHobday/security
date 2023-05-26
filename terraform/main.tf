locals {
    common_tags = {
        owner = var.owner
        project = var.project
        environment = "staging"
    }
}