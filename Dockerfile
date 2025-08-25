# ===== STAGE 1: Dependencies =====
FROM node:15.14.0-alpine3.13 AS dependencies

WORKDIR /app

# Install build dependencies for node-sass
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# ===== STAGE 2: Build =====
FROM node:15.14.0-alpine3.13 AS builder

WORKDIR /app

# Copy dependencies from previous stage
COPY --from=dependencies /app/node_modules ./node_modules
COPY package*.json ./

# Copy source code
COPY public/ ./public/
COPY src/ ./src/

# Build the application
RUN npm run build

# ===== STAGE 3: Production =====
FROM node:15.14.0-slim AS production

WORKDIR /app

# Install serve globally
RUN npm install -g serve

# Copy built application from builder stage
COPY --from=builder /app/build ./build

# Create non-root user for security
# RUN addgroup -g 1001 -S appuser
# RUN adduser -S appuser -u 1001

# Change ownership of the app directory
# RUN chown -R appuser:appuser /app
# USER appuser

# Expose port 8080 to match the CMD
EXPOSE 8080

# Start the application
CMD ["serve", "-s", "build", "-l", "8080"]