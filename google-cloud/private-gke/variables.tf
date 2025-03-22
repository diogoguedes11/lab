# ---------------------------------------------------------------------------------------------------------------------
# Parameters 
# ---------------------------------------------------------------------------------------------------------------------
variable "env" {
  description = "List of environments"
  type = map(object({
    project        = string,
    region         = string,
    zone           = string,
    create-network = bool,
    network        = string,
    create-sql     = bool
    compute-image  = string
    create-vm      = bool
    create-gke     = bool
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Local variables
# ---------------------------------------------------------------------------------------------------------------------

locals {

  region  = var.env[terraform.workspace].region
  zone    = var.env[terraform.workspace].zone
  project = var.env[terraform.workspace].project
  env     = terraform.workspace

  # Network
  create-network = var.env[terraform.workspace].create-network
  network        = var.env[terraform.workspace].network
  compute-image  = var.env[terraform.workspace].compute-image
  create-vm      = var.env[terraform.workspace].create-vm
  # SQL
  create-sql = var.env[terraform.workspace].create-sql
  # GKE
  create-gke = var.env[terraform.workspace].create-gke
}

