# AssayDepot

Ruby interface for Assay Depot's online laboratory (http://www.assaydepot.com).

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
  config.auth_token = "1234567890"
  config.url = "http://localhost:3000/api"
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
providers = AssayDepot::Provider.where(:starts_with => "a").per_page(600)
providers.count
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
