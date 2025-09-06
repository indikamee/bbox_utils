# Dockerfile.rails
FROM ruby:2.7.1

RUN apt-get update
RUN apt-get --assume-yes install nodejs
ADD . /mora_tickets
WORKDIR /mora_tickets
RUN bundle install

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

EXPOSE 3000
CMD ["bash"]
