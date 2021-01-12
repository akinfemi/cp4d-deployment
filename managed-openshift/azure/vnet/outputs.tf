output "virtual_network_name" {
    value = local.virtual_network
}

output "network_cidr" {
    value = var.network_cidr
}

output "master_subnet_id" {
    value = local.master_subnet_id
}

output "worker_subnet_id" {
    value = local.worker_subnet_id
}