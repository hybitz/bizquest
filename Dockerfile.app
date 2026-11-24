ARG registry
FROM ${registry}/bizquest/base:latest AS build

ADD . ./
RUN yarn build && yarn build:css && cargo build --release

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

RUN addgroup -S -g 10001 bizquest && adduser -S -D -H -u 10001 -G bizquest bizquest

WORKDIR /app
COPY --from=build /app/target/release/bizquest /usr/local/bin/bizquest
COPY --from=build /app/public ./public
COPY --from=build /app/app/assets/builds ./app/assets/builds

USER 10001:10001

EXPOSE 3000
CMD ["bizquest"]
