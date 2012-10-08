# Assay Depot

Ruby interface for Assay Depot's online laboratory (http://www.assaydepot.com).

## Assay Depot Developer Program

An authentication token is required for the API to function. If you would like access to the API, please email cpetersen@assaydepot.com.

## Installation

Add this line to your application's Gemfile:

    gem 'assaydepot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install assaydepot

## Basic Usage

```ruby
require 'assaydepot'
AssayDepot.configure do |config|
  config.access_token = "1234567890"
  config.url = "https://www.assaydepot.com/api"
end
wares = AssayDepot::Ware.find("Antibody")
wares.total
```

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

The Assay Depot Ruby SDK is released under the MIT license.


