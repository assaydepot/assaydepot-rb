# Assay Depot ![Build Status](https://secure.travis-ci.org/assaydepot/assaydepot-rb.png) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/assaydepot/assaydepot-rb)

Ruby interface for Assay Depot's online laboratory (http://www.assaydepot.com).

## Scientist.com Developer Program

An authentication token is required for the API to function. If you would like access to the API, please email support@scientist.com.

## Installation

Add this line to your application's Gemfile:

    gem 'assaydepot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assaydepot

## Basic Usage

### Storefront

```ruby
require 'assaydepot'
AssayDepot.configure do |config|
  config.access_token = "1234567890"
  config.url = "https://app,scientist.com"
end
wares = AssayDepot::Ware.find("Antibody")
wares.total
```

### Backoffice

```ruby
require 'assaydepot'
AssayDepot.configure do |config|
  config.access_token = "1234567890"
  config.url = "https://backoffice,scientist.com"
end
quoted_ware = AssayDepot::QuotedWare.get()
```

## API Documentation
See the [Scientist.com API documentation](https://assaydepot.github.io/scientist_api_docs/#introduction) for details on the Scientist.com API resources and code examples using this SDK.

## Using Facets

```ruby
wares = AssayDepot::Ware.where(:ware_type => "CustomService")
wares.facets
```

## Chainable Commands

```ruby
wares = AssayDepot::Ware.where(:ware_type => "CustomService").where(:available_provider_names => "Assay Depot").page(2)
wares.first["name"]
```

## Providers

```ruby
providers = AssayDepot::Provider.where(:starts_with => "a").per_page(50)
providers.count
```

## Get Details
```ruby
providers = AssayDepot::Provider.where(:starts_with => "a")
AssayDepot::Provider.get(providers.first["id"])
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The Scientist.com Ruby SDK is released under the MIT license.
