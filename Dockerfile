# ===== STAGE 1: Dependencies =====
FROM node:15.14.0-alpine3.13 

WORKDIR /app
# Install build dependencies for node-sass
RUN apk add --no-cache python3 make g++
# Copy package files
COPY package*.json ./
# Install dependencies
RUN npm install
# Install serve globally
RUN npm install -g serve
# Copy source code
COPY public/ ./public/
COPY src/ ./src/
# Build the application
RUN npm run build
# Expose port 8080
EXPOSE 8080
# Start the application
CMD ["serve", "-s", "build", "-l", "8080"]