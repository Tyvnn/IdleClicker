terraform {
  cloud {
    organization = "MSSADEVOPSPROJ"

    workspaces {
      name = "terraform-ansible"
    }
  }
}