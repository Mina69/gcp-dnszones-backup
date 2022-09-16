gcp_project         = "demo-kub-sbx"
environment         = "sbx"
schedule_time       = "0 17 * * *"
app_labels = {
    environment = "sbx"
    app_name    = "dnszones-backup"
  }
  