# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_recommendations/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_recommendations'
  s.version     = SolidusRecommendations::VERSION
  s.summary     = 'Recommendations for Solidus'
  s.description = 'Recommendations for Solidus using Elasticsearch significant terms aggregation'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Taylor Scott'
  s.email     = 't.skukx@gmail.com'
  s.homepage  = 'https://github.com/skukx'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus_core'

  # Auto-Generated dependencies
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
