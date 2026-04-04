# Install dependencies only when needed
FROM node:25-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm@latest
RUN pnpm install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:25-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
COPY docker/middleware.ts ./src

ARG DATABASE_TYPE
ARG BASE_PATH
ENV DATABASE_TYPE=$DATABASE_TYPE
ENV BASE_PATH=$BASE_PATH
ENV NEXT_TELEMETRY_DISABLED=1

RUN npm run build-docker

# Production image, copy all the files and run next
FROM node:25-alpine AS runner
WORKDIR /app

ARG NODE_OPTIONS
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS=$NODE_OPTIONS

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
RUN npm install -g pnpm@latest
RUN set -x \
    && apk add --no-cache curl


ADD https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem /app/rds-ca.pem

# Copy package files first
COPY package.json pnpm-lock.yaml ./

# Install ALL dependencies (including script dependencies)
RUN pnpm install --frozen-lockfile --prod=false

# Permissions for node_modules
RUN chown -R nextjs:nodejs node_modules/

COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/generated ./generated

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV HOSTNAME=0.0.0.0
ENV PORT=3000
CMD ["pnpm", "start-docker"]
