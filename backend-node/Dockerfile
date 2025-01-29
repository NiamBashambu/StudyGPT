# Use Node.js image
FROM node:20

# Set working directory
WORKDIR /root/StudyGPT

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the application code
COPY . .

# Expose the port
EXPOSE 4000

# Start the application
CMD ["npm", "start"]