# OpenscapParser

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/openscap_parser`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openscap_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openscap_parser

## Usage

ARF/XCCDF report goes IN - Ruby hash goes OUT

```rb
parser = OpenscapParser::Base.new(File.read('rhel7-xccdf_org.ssgproject.content_profile_standard.xml'))
parser.host # "rhel7-insights-client.virbr0.akofink-laptop"
parser.start_time # <DateTime: 2019-08-08T17:25:50+00:00 ((2458704j,62750s,0n),+0s,2299161j)>
parser.end_time # <DateTime: 2019-08-08T17:26:45+00:00 ((2458704j,62805s,0n),+0s,2299161j)>
parser.score # 80.833328
parser.profiles # {"xccdf_org.ssgproject.content_profile_standard"=>"Standard System Security Profile for Red Hat Enterprise Linux 7"}
parser.rules # [#<OpenscapParser::Rule:0x00005576e752db7 ... >, ...]
parser.rule_results # [#<OpenscapParser::RuleResult:0x00005576e8022f60 @id="xccdf_org.ssgproject.content_rule_package_rsh_removed", @result="notselected">, ...]

# and more!
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### With Docker

A Dockerfile is provided to allow a containerized development environment:

```
docker build . -t openscap_parser # build the container image
docker run -itv $PWD:/app:z openscap_parser rake # run tests
docker run -itv $PWD:/app:z openscap_parser pry --gem # console
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/elobato/openscap_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the OpenscapParser project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/elobato/openscap_parser/blob/master/CODE_OF_CONDUCT.md).
