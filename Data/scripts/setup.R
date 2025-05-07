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