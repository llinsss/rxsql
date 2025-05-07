# Setup script for Customer Analytics project
# This script installs and loads required packages and sets up the database connection

# Function to install packages if not already installed
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    message(paste("Installing package:", package))
    install.packages(package)
    library(package, character.only = TRUE)
  } else {
    message(paste("Package", package, "is already installed"))
  }
}
# List of required packages
required_packages <- c(
  "DBI",          # Database interface
  "RSQLite",      # SQLite connection
  "dplyr",        # Data manipulation
  "ggplot2",      # Data visualization
  "tidyr",        # Data tidying
  "lubridate",    # Date handling
  "readr",        # Reading data
  "knitr",        # Report generation
  "rmarkdown"     # Report generation
)

# Install and load all required packages
sapply(required_packages, install_if_missing)

# Create database connection
setup_database <- function() {
  # Check if the data directory exists, if not create it
  if (!dir.exists("data")) {
    dir.create("data")
    message("Created 'data' directory")
  }
  # Check if the outputs directory exists, if not create it
  if (!dir.exists("outputs")) {
    dir.create("outputs")
    message("Created 'outputs' directory")
  }
  
  # Create database connection
  db_path <- "data/customer_db.sqlite"
  conn <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  
  # Check if the database needs to be initialized
  if (!file.exists(db_path) || file.size(db_path) == 0) {
    message("Initializing the database...")
    
    # Read and execute the SQL script
    sql_script <- readLines("data/create_database.sql")
    sql_script <- paste(sql_script, collapse = "\n")

    # Split the script into separate statements
    sql_statements <- strsplit(sql_script, ";")[[1]]
    
    # Execute each statement
    for (statement in sql_statements) {
      if (trimws(statement) != "") {
        DBI::dbExecute(conn, statement)
      }
    }
    
    message("Database initialized successfully")
  } else {
    message("Database already exists")
  }
  # Return the connection
  return(conn)
}

# Setup the database and return the connection
conn <- setup_database()

# Test the connection by listing tables
tables <- DBI::dbListTables(conn)
message("Database contains the following tables:")
print(tables)

# Close the connection
DBI::dbDisconnect(conn)
message("Database connection closed")

message("Setup completed successfully")