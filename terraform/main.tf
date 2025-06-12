
locals {
  tags = {
    Application = "psf"
    Environment = "Production"
    Terraform   = "managed"
  }
}

# module "dns" {
# source = "./dns"
#
# tags                = local.tags
# primary_domain      = "python.org"
# user_content_domain = "python.org" # TODO
#
# caa_report_uri = "mailto:infrastructure-staff@python.org"
# caa_issuers = [
# "amazon.com",
# "globalsign.com",
# "letsencrypt.org",
# ]
#
# apex_txt = [
# ]
# }

module "synthetics" {
  source = "./synthetics"

  tags         = local.tags
  fastly_token = var.fastly_token
}
