FROM node:16 as dependencies
WORKDIR /SolNFT-DiscordBot
COPY package.json yarn.lock .env ./
RUN yarn install --frozen-lockfile

FROM node:16 as builder
WORKDIR /SolNFT-DiscordBot
COPY . .
COPY --from=dependencies /SolNFT-DiscordBot/node_modules ./node_modules
COPY --from=dependencies /SolNFT-DiscordBot/.env ./.env
RUN yarn build

FROM node:16 as runner
WORKDIR /SolNFT-DiscordBot
ENV NODE_ENV production
# If you are using a custom next.config.js file, uncomment this line.
# COPY --from=builder /SolNFT-DiscordBot/next.config.js ./
COPY --from=builder /SolNFT-DiscordBot/dist ./dist
COPY --from=builder /SolNFT-DiscordBot/node_modules ./node_modules
COPY --from=builder /SolNFT-DiscordBot/package.json ./package.json
COPY --from=builder /SolNFT-DiscordBot/.env ./.env

EXPOSE 4000
CMD ["yarn", "start"]
