

app_name <- config::get(file = "shiny_app/config.yml")$app_name
rsconnect::deployApp(
 appDir = "shiny_app",
 account = "shivani1",
 appName = app_name
)



