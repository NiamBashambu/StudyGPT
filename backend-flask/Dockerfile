# Use Python image
FROM python:3.12

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the application code
COPY . .

# Expose the port
EXPOSE 5000

# Start the Flask app
CMD ["python", "ai-model.py"]