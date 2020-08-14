# Minitest::Jsonapi

Sends JSON output for Minitest runs to console or to a specific URL via `POST` with a predefined API key and value.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minitest-jsonapi', require: false
```

And then execute:

	> bundle

Or install it yourself as:

	> gem install minitest-jsonapi

## Usage

### From terminal
---

To generate reports using Minitest::JsonApi, you'll need to pass `-J` or `--json` flag to Minitest on the command line.

Following will produce the output on the terminal:

	> ruby test/foo_test.rb -J

Options to specify the URL and API keys & values:

	> ruby test/foo_test.rb -J --addr=http://localhost:4567 --keyname=ABCD --keyvalue=EFGH

To prettify the JSON for terminal output:

	> ruby test/foo_test.rb -J --pretty

All options are optional.

All the options can be viewed by using `-h` for help:

	> ruby test/foo_test.rb -h


### From rakefile
---

You can set up a rake task to run all your tests by adding this to your Rakefile:

```ruby
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
	t.options = '-J --addr=http://localhost:4567/ --keyname=ABCD --keyvalue=EFGH'
	t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test
```

You can also switch on JSON output globally for every test run by putting the following in your test helper:

```ruby
Minitest::JsonApi.enable!
```


## Development

This repository is a mirror of the public [fossil](https://fossil-scm.org) repository hosted at [fossil.abhij.it/repos/minitest-jsonapi](https://fossil.abhij.it/repos/minitest-jsonapi)

No pull requests are accepted through this repository. Email mail@abhij.it to discuss features.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
