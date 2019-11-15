# docker build . -t openscap_results_parser # build the container image
# docker run -itv $PWD:/app:z openscap_results_parser rake # run tests
# docker run -itv $PWD:/app:z openscap_results_parser pry --gem # console

FROM ruby:2.5

RUN gem update bundler

WORKDIR /app

COPY . ./

RUN bundle -j4

CMD bash
