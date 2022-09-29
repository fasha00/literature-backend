FROM node:14
WORKDIR /app
COPY . .
ENV DATABASE_URL POSTGRES://fasha:fasha123@103.183.74.5/literature
ENV NODE_ENV production
RUN npm install
RUN npm i -g pnpm
RUN npm install -g sequelize-cli
RUN npx sequelize db:migrate --env=production
EXPOSE 5000
CMD ["pnpm", "start"]
