# Base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the app port
EXPOSE 5000

# Run the app
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0", "--port=5000"]





