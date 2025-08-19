# ---- Stage 1: Build the Vite Application ----
# Use a stable Node.js image as the "builder"
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and lock files
COPY package*.json ./

# Install all project dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Run the build command to generate the static files
RUN npm run build


# ---- Stage 2: Serve the application with NGINX ----
# Use a lightweight, official NGINX image for the final product
FROM nginx:stable-alpine

# IMPORTANT: Copy the built files from the 'dist' folder (for Vite)
COPY --from=builder /app/dist /usr/share/nginx/html

# Tell Docker that the container will listen on port 80
EXPOSE 80

# The default command to start the NGINX server
CMD ["nginx", "-g", "daemon off;"]