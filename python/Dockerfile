# Use an official Python runtime as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Python script into the container
COPY update_json.py .

# (Optional) Install any dependencies if your script requires them
# RUN pip install --no-cache-dir requests pandas numpy  # <- Example packages

# Specify the command to run when the container starts
CMD ["python", "update_json.py"]