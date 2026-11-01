
# =========================
# Stage 1: Build
# =========================
FROM node:20-alpine AS build

# Update Alpine security packages
RUN apk upgrade --no-cache

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy application source
COPY . .

# Build frontend
RUN npm run build


# =========================
# Stage 2: Production
# =========================
FROM nginx:alpine AS production

# Update production image security packages
RUN apk upgrade --no-cache

# Copy production build
COPY --from=build /app/dist/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
