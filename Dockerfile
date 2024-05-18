###################
# BUILD FOR LOCAL DEVELOPMENT
###################

FROM --platform=linux/arm64 node:18-alpine AS development

# Create app directory
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Check if package-lock.json exists and install dependencies
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Bundle app source
COPY . .

# Use the node user from the image (instead of the root user)
USER node

###################
# BUILD FOR PRODUCTION
###################

FROM --platform=linux/arm64 node:18-alpine AS build

WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Copy the node_modules from the development stage
COPY --from=development /usr/src/app/node_modules ./node_modules

# Bundle app source
COPY . .

# Run the build command which creates the production bundle
RUN npm run build

# Set NODE_ENV environment variable
ENV NODE_ENV production

# Remove development dependencies
RUN npm ci --only=production && npm cache clean --force

USER node

###################
# PRODUCTION
###################

FROM --platform=linux/arm64 node:18-alpine AS production

WORKDIR /usr/src/app

# Copy the production node_modules and dist from the build stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/dist ./dist

# Use the node user from the image (instead of the root user)
USER node

# Start the server using the production build
CMD ["node", "dist/main.js"]