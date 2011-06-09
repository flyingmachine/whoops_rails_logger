# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "whoops_rails_notifier"
  s.summary = "A Whoops Notifier for Rails 3 apps."
  s.description = "A Whoops Notifier for Rails 3 apps."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
  
  s.add_dependency("whoops_notifier")
  s.add_dependency('rails', '~>3')

  s.add_development_dependency('rspec', '2.1.0')
  s.add_development_dependency('rspec-rails')
  s.add_development_dependency('ruby-debug')
  s.add_development_dependency("capybara", "0.4.0")
end