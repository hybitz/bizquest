ARG registry
FROM ${registry}/bizquest/base:latest

EXPOSE 3000

ADD  . ./
RUN sudo chown -R ${USER}:${USER} ./ && \
    bundle exec rake assets:precompile RAIL_ENV=production
