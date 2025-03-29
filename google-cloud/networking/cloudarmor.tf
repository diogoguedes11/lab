# Challenge
# Allow traffic from my local machine but not from cloud shell
resource "google_compute_security_policy" "this" {
  name = "lb-policy"

  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"
  }
  rule {
    action   = "deny(403)"
    priority = "5000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
    description = "Deny access to IPs in 0.0.0.0/0"
  }
  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["85.240.240.153/32"]
      }
    }
    description = "default rule"
  }
}
