data "terraform_remote_state" "core" {
  backend = "local"

  config = {
    path = "../tf-core/terraform.tfstate"
  }
}
