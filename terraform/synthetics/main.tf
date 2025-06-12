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
# ---

# Buildbot
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

# docs-backend
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

# docs.python.org
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

# PSF Members
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

# PyCon US
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

# PyPI - Backends
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

# PyPI - CDN
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

# PyPI - Inspector
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

# Python.org - Backends
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

# Roundup
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

# Wiki
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
