variable "datadog_api_key" {
  description = "Datadog API key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Datadog application key"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "Datadog API URL"
  type        = string
  default     = "https://api.datadoghq.com"
}

resource "datadog_monitor" "example_monitor" {
  name    = "Example HTTP check"
  type    = "service check"
  message = "This monitor triggers when the service check fails."

  query = """
    "http.can_connect".over("env:prod").by("host").last(5).count_by_status()
  """

  tags = ["env:prod", "team:platform"]

  monitor_thresholds {
    ok       = 1
    warning  = 1
    critical = 2
  }

  notify_no_data    = false
  renotify_interval = 0
}

resource "datadog_dashboard" "example_dashboard" {
  title        = "Example Dashboard"
  description  = "A simple Datadog dashboard generated with Terraform"
  layout_type  = "ordered"
  is_read_only = true

  widget {
    alert_graph_definition {
      title = "Alert graph"
      request {
        q = "avg:system.cpu.user{*} by {host}"
      }
    }
  }
}
