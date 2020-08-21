FROM ruby:2.6.5
MAINTAINER JeongWooYeong(wjd030811@gmail.com)

ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV SCARFS_PRODUCTION_PASSWORD $SCARFS_PRODUCTION_PASSWORD
ENV SCARFS_PRODUCTION_HOST $SCARFS_PRODUCTION_HOST
ENV SCARFS_PRODUCTION_REDIS $SCARFS_PRODUCTION_REDIS
ENV MAILGUN_API_KEY $MAILGUN_API_KEY
ENV RAILS_ENV production

RUN apt-get update
RUN apt-get install -y default-libmysqlclient-dev

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

RUN gem install bundler

RUN mkdir rib-eye
COPY . rib-eye
WORKDIR rib-eye

RUN bundle install --without development test

EXPOSE 3001

ENTRYPOINT ["bundle", "exec", "sidekiq"]
CMD ["-e", "production"]

ENTRYPOINT ["rails", "server"]
CMD ["-b", "0.0.0.0", "-p", "3001"]
