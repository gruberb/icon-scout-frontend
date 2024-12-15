# Stage 1: Build the frontend
FROM node:18-bullseye-slim as build
WORKDIR /app

# Copy only package files first for caching
COPY package*.json ./

# Install dependencies in a clean environment
# If you have a package-lock.json, prefer `npm ci` for reproducible builds.
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the production version of the frontend
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
