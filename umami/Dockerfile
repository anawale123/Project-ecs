FROM node:22-alpine AS deps

# Install libc6-compat and build tools for Alpine
RUN apk add --no-cache libc6-compat python3 make g++ bash curl

WORKDIR /app

# Copy only lockfiles to leverage caching
COPY package.json pnpm-lock.yaml ./

# Install pnpm and project dependencies
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

FROM node:22-alpine AS builder

WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Pass build-time args (must be set in CI)
ARG DATABASE_TYPE
ARG BASE_PATH

ENV DATABASE_TYPE=$DATABASE_TYPE
ENV BASE_PATH=$BASE_PATH
ENV NEXT_TELEMETRY_DISABLED=1

# Build the project
RUN npm run build-docker

FROM node:22-alpine AS runner

WORKDIR /app

ARG NODE_OPTIONS
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS=$NODE_OPTIONS

# Create non-root user
RUN addgroup --system --gid 1001 nodejs \
    && adduser --system --uid 1001 nextjs

# Install pnpm globally
RUN npm install -g pnpm

# Install runtime dependencies for scripts
RUN pnpm add npm-run-all dotenv prisma@6.7.0

# Fix permissions for Prisma
RUN chown -R nextjs:nodejs node_modules/.pnpm/

# Copy built files and static
