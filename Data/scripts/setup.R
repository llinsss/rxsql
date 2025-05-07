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