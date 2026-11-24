ARG registry
FROM ${registry}/bizquest/base:latest AS build

ADD . ./
RUN yarn build && yarn build:css && cargo build --release

FROM alpine:3.24.4@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

WORKDIR /app
COPY --from=build /app/target/release/bizquest /usr/local/bin/bizquest
COPY --from=build /app/public ./public
COPY --from=build /app/app/assets/builds ./app/assets/builds

EXPOSE 3000
CMD ["bizquest"]
