# Required in modules 🤷🏼‍♀️
terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "3.65.0"
    }
  }
}

# ---
# Configuration for DataDog Synthetics
# Standardized config is in variables.tf
# but can be overriden easily
#
# TODO: extract the common assertions and options into a module or
#       something to avoid all this duplication :(
# ---

resource "datadog_synthetics_test" "buildbot" {
  name      = "Buildbot"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://buildbot.python.org/all/#/about"
  }

  assertion {
    type     = local.standard_assertions.response_time_4000.type
    operator = local.standard_assertions.response_time_4000.operator
    target   = local.standard_assertions.response_time_4000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html.type
    property = local.standard_assertions.content_type_html.property
    operator = local.standard_assertions.content_type_html.operator
    target   = local.standard_assertions.content_type_html.target
  }

  assertion {
    type     = "body"
    operator = "contains"
    target   = "Buildbot"
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 180
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "docs_backend" {
  name      = "docs-backend"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://lb.nyc1.psf.io:20004/"
  }

  request_headers = {
    "Fastly-Token" = var.fastly_token
    "Host"         = "docs.python.org"
  }

  assertion {
    type     = local.standard_assertions.response_time_3000.type
    operator = local.standard_assertions.response_time_3000.operator
    target   = local.standard_assertions.response_time_3000.target
  }

  assertion {
    type     = local.standard_assertions.status_302.type
    operator = local.standard_assertions.status_302.operator
    target   = local.standard_assertions.status_302.target
  }

  assertion {
    type     = "header"
    property = "location"
    operator = "is"
    target   = "https://docs.python.org/3/"
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed
    allow_insecure       = true
    http_version         = "http1"
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "docs_python_org" {
  name      = "docs.python.org"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://docs.python.org/3/"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html.type
    property = local.standard_assertions.content_type_html.property
    operator = local.standard_assertions.content_type_html.operator
    target   = local.standard_assertions.content_type_html.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "psf_members" {
  name      = "PSF Members"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://psfmember.org/ "
  }

  assertion {
    type     = local.standard_assertions.response_time_4000.type
    operator = local.standard_assertions.response_time_4000.operator
    target   = local.standard_assertions.response_time_4000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 180
    min_location_failed  = local.default_options.min_location_failed
    http_version         = "http1"

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "pycon_us" {
  name      = "PyCon US"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://us.pycon.org/2025/"
  }

  assertion {
    type     = local.standard_assertions.response_time_1000.type
    operator = local.standard_assertions.response_time_1000.operator
    target   = local.standard_assertions.response_time_1000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = "header"
    property = "content-type"
    operator = "is"
    target   = "text/html; charset=utf-8"
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 180
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "pypi_backends" {
  name      = "PyPI - Backends"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://warehouse.ingress.us-east-2.pypi.io/_health/"
  }

  request_headers = {
    "Host" = "pypi.org"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 60
    min_location_failed  = local.default_options.min_location_failed
    allow_insecure       = true
    http_version         = "http1"

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "pypi_cdn" {
  name      = "PyPI - CDN"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://pypi.org/_health/"
  }

  assertion {
    type     = local.standard_assertions.response_time_1000.type
    operator = local.standard_assertions.response_time_1000.operator
    target   = local.standard_assertions.response_time_1000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 60
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "pypi_inspector" {
  name      = "PyPI - Inspector"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://inspector.pypi.io/"
  }

  assertion {
    type     = local.standard_assertions.response_time_3000.type
    operator = local.standard_assertions.response_time_3000.operator
    target   = local.standard_assertions.response_time_3000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 180
    min_location_failed  = local.default_options.min_location_failed
    http_version         = "http1"

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "python_org_backends" {
  name      = "Python.org - Backends"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://pythondotorg.ingress.us-east-2.psfhosted.computer/_health"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 60
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "roundup" {
  name      = "Roundup"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.reduced_locations

  request_definition {
    method = "GET"
    url    = "https://bugs.python.org/user22804"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "10000"
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 300
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "wiki" {
  name      = "Wiki"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.reduced_locations

  request_definition {
    method = "GET"
    url    = "https://wiki.python.org/moin/"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "5000"
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = "body"
    operator = "contains"
    target   = "FrontPage"
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 300
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "files_pythonhosted_org_backend_files" {
  name      = "files.pythonhosted.org - Backend Files"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://files.pythonhosted.org/packages/aa/aa/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/aaaaaaaaa-0.0.0.tar.gz"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "files_pythonhosted_org_backend_redirects" {
  name      = "files.pythonhosted.org - Backend Redirects"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://conveyor.ingress.us-east-2.pypi.io/_health"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "files_pythonhosted_org_cdn_files" {
  name      = "files.pythonhosted.org - CDN Files"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://files.pythonhosted.org/packages/bb/69/a9fb8adbbc0a7b0c865e828389bafad5225f3ca098f8d444c3d6400ce6f8/clandestined-1.0.1.tar.gz"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "files_pythonhosted_org_cdn_redirects" {
  name      = "files.pythonhosted.org - CDN Redirects"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://files.pythonhosted.org/packages/source/c/clandestined/clandestined-1.0.1.tar.gz"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "python_org_cdn" {
  name      = "python.org - CDN"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://www.python.org/"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "python_org_downloads_backend" {
  name      = "python.org - downloads backend"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://lb.nyc1.psf.io:20004/ftp/"
  }

  request_headers = {
    "Fastly-Token" = var.fastly_token
    "Host"         = "www.python.org"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "mail_python_org_mm" {
  name      = "mail.python.org - mm"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://mail.python.org/mailman3/lists/"
  }

  assertion {
    type     = local.standard_assertions.response_time_3000.type
    operator = local.standard_assertions.response_time_3000.operator
    target   = local.standard_assertions.response_time_3000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "mail_python_org_smtp" {
  name      = "mail.python.org smtp"
  type      = "api"
  subtype   = "tcp"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    host = "mail.python.org"
    port = 25
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "3000"
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "lb_0_nyc1_psf_io" {
  name      = "lb-0.nyc1.psf.io"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://lb-0.nyc1.psf.io/_haproxy_status"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "lb_1_nyc1_psf_io" {
  name      = "lb-1.nyc1.psf.io"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://lb-1.nyc1.psf.io/_haproxy_status"
  }

  assertion {
    type     = local.standard_assertions.response_time_2000.type
    operator = local.standard_assertions.response_time_2000.operator
    target   = local.standard_assertions.response_time_2000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "hg_python_org" {
  name      = "hg.python.org (HTTPS)"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://hg.python.org/"
  }

  assertion {
    type     = local.standard_assertions.response_time_3000.type
    operator = local.standard_assertions.response_time_3000.operator
    target   = local.standard_assertions.response_time_3000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "python_speed" {
  name      = "python speed"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://speed.python.org/changes/"
  }

  assertion {
    type     = local.standard_assertions.response_time_3000.type
    operator = local.standard_assertions.response_time_3000.operator
    target   = local.standard_assertions.response_time_3000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}

resource "datadog_synthetics_test" "pypy_speed" {
  name      = "pypy speed"
  type      = "api"
  subtype   = "http"
  status    = "live"
  locations = local.standard_locations

  request_definition {
    method = "GET"
    url    = "https://speed.pypy.org/"
  }

  assertion {
    type     = local.standard_assertions.response_time_3000.type
    operator = local.standard_assertions.response_time_3000.operator
    target   = local.standard_assertions.response_time_3000.target
  }

  assertion {
    type     = local.standard_assertions.status_200.type
    operator = local.standard_assertions.status_200.operator
    target   = local.standard_assertions.status_200.target
  }

  assertion {
    type     = local.standard_assertions.content_type_html_utf8.type
    property = local.standard_assertions.content_type_html_utf8.property
    operator = local.standard_assertions.content_type_html_utf8.operator
    target   = local.standard_assertions.content_type_html_utf8.target
  }

  options_list {
    tick_every           = local.default_options.tick_every
    min_failure_duration = 0
    min_location_failed  = local.default_options.min_location_failed

    retry {
      count    = local.default_options.retry_count
      interval = local.default_options.retry_interval
    }
  }

  tags = local.synthetics_tags
}
