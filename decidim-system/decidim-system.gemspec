# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "decidim/system/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.version = Decidim::System.version
  s.authors = ["Josep Jaume Rey Peroy", "Marc Riera Casals", "Oriol Gual Oliva"]
  s.email = ["josepjaume@gmail.com", "mrc2407@gmail.com", "oriolgual@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim"
  s.required_ruby_version = ">= 2.3"

  s.name = "decidim-system"
  s.summary = "Decidim system administration"
  s.description = "System administration to create new organization in an installation."

  s.files = Dir["{app,config,db,lib,vendor}/**/*", "Rakefile", "README.md"]

  compatible_constraint = "#{Gem::Version.new(s.version).approximate_recommendation}.a"

  s.add_dependency "active_link_to", "~> 1.0"
  s.add_dependency "decidim-core", compatible_constraint
  s.add_dependency "devise", "~> 4.2"
  s.add_dependency "devise-i18n", "~> 1.2"
  s.add_dependency "devise_invitable", "~> 1.7"
  s.add_dependency "jquery-rails", "~> 4.3"
  s.add_dependency "sassc", "~> 1.12", ">= 1.12.1"
  s.add_dependency "sassc-rails", "~> 1.3"

  s.add_development_dependency "decidim-dev", compatible_constraint
end
