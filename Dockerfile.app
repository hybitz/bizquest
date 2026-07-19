ARG registry
FROM ${registry}/bizquest/base:latest AS build

ADD . ./
RUN yarn build && yarn build:css && cargo build --release

FROM alpine:3.21

WORKDIR /app
COPY --from=build /app/target/release/bizquest /usr/local/bin/bizquest
COPY --from=build /app/public ./public
COPY --from=build /app/app/assets/builds ./app/assets/builds

EXPOSE 3000
CMD ["bizquest"]
