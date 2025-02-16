# Use a lightweight Debian-based image with bash
FROM debian:stable-slim

# Install necessary core utilities (ensure find, sort, sed, grep are available)
RUN apt-get update && apt-get install -y --no-install-recommends \
  coreutils \
  jq \
  && rm -rf /var/lib/apt/lists/*

# Copy the script into the container
COPY generate_json.sh /app/generate_json.sh

# Make the script executable
RUN chmod +x /app/generate_json.sh

# Set working directory for data access
WORKDIR /data

# Set default environment variable (can be overridden)
ENV SERIES_NAME="Default Series"

# Set the entrypoint to run the script
ENTRYPOINT ["/app/generate_json.sh"]