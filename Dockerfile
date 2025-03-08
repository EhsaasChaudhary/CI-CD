# syntax=docker/dockerfile:1

# Stage 1: Install dependencies
FROM node:lts-alpine AS builder
WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./
RUN npm install --only=production

# Copy application code
COPY . .

# Stage 2: Create the final image
FROM node:lts-alpine AS runtime
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

# Expose port
EXPOSE 3000

# Start application
CMD ["node", "src/index.js"]
