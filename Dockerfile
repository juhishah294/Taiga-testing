# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /taiga-back

# Install system dependencies and Python packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    gettext \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages directly
RUN pip install --upgrade pip \
    && pip install django \
    && pip install psycopg2-binary \
    && pip install celery \
    # Install any other packages your application needs here
    # Example: pip install requests

# Copy the current directory contents into the container
COPY . /taiga-back/

# Run Django management commands
RUN python manage.py collectstatic --noinput \
    && python manage.py compilemessages

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["sh", "-c", "python manage.py migrate && gunicorn -b 0.0.0.0:8000 taiga.wsgi"]
