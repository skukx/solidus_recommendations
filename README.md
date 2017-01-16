SolidusRecommendations
======================

Uses Elasticsearch on top of Solidus framework to retrieve relevant recommendations based on what users have purchased in the past.

Installation
------------

Add solidus_recommendations to your Gemfile:

```ruby
gem 'solidus_recommendations'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_recommendations:install
```

From the console:
```ruby
Spree.user_class.__elasticsearch__.create_index!
Spree::Order.__elasticsearch__.create_index!

Spree.user_class.import
Spree::Order.import
```

Usage
-----

We can get recommendations based on the product `123` by doing the following:
```ruby
Spree::Product.recommendations.get(123)
```

The query defaults to at most 10 results, If you want more or less then you can use the `size` argument.
```ruby
Spree::Product.recommendations.get(123, size: 5) # At most 5 results.
```

(Experimental) Currently we index the products a user has purchased as well as the products within each order. These two indices can say different things about our data.  The user index gives results for "What did other users purchase that also purchased this product". The order index is for "What did other users checkout with that also checked out with this product". By default the user index is used to query for recommendations but that can be changed using the `index` argument. Acceptable values are `[:user, :order]`.
```ruby
Spree::Product.recommendations.get(123, index: :order)
```

Testing
-------

Install [elasticsearch](https://www.elastic.co/downloads/elasticsearch), this is needed for rspec tests. If you have issues running tests, see [https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-extensions#testcluster](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-extensions#testcluster)

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs, and [Rubocop](https://github.com/bbatsov/rubocop) static code analysis. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_recommendations/factories'
```

Copyright (c) 2017 [name of extension creator], released under the New BSD License
