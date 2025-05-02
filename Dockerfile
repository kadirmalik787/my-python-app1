# Use Python base image
FROM python:3.9

# Set working directory inside container
WORKDIR /app

# Copy files
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Expose port
EXPOSE 8075

# Command to run the app
CMD ["python", "app.py"]

