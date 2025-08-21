############
# Policies #
############

resource "cloudflare_zero_trust_access_policy" "only_us_ips" {
  account_id = var.account_id
  decision = "allow"
  include = [{
    geo = {
      country_code = "US"
    }
  }]
  name = "Allow only US IPs"
  isolation_required = false # Does not need special browser
}


resource "cloudflare_zero_trust_access_policy" "bypass_cloudflare_login" {
  account_id = var.account_id
  decision = "bypass"
  include = [{
    everyone = {}
  }]
  name = "Bypass Cloudflare Login"
  isolation_required = false # Does not need special browser
}


########################
# Trusted Email Policy #
########################

resource "cloudflare_zero_trust_list" "trusted_emails" {
  account_id  = var.account_id
  name        = "Trusted Emails"
  description = "Allowed users"
  type        = "EMAIL"
  items       = [{
        value = "ezq.valencia@gmail.com"
    }, {
        value = "wzeke123@gmail.com"
    }
  ]
}


resource "cloudflare_zero_trust_access_policy" "only_trusted_emails" {
  account_id = var.account_id
  decision = "allow"
  include = [{
    email_list = {
      id = cloudflare_zero_trust_list.trusted_emails.id
    },
    login_method = {
      id = cloudflare_zero_trust_access_identity_provider.zone_otp.id
    }
  }]
  name = "Only trusted emails."
  isolation_required = false # Does not need special browser
  session_duration = "8760h" # 1 Year
}

resource "cloudflare_zero_trust_access_identity_provider" "zone_otp" {
  config = { }
  name = "Zones OTP"
  type = "onetimepin"
  account_id = var.account_id
}


