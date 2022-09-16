gcp_project         = "demo-kub-prd"
environment         = "prd"
schedule_time       = "0 17 * * *"
app_labels = {
    environment = "prd"
    app_name    = "dnszones-backup"
  }