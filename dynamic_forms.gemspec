# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "dynamic_forms"
  s.authors     = ["Mwaki Harri Magotswi", "Tom Cocca"]
  s.summary = "Rails engine to allow your users to build their own forms in your app.."
  s.description = "Rails engine to allow your users to build their own forms in your app."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.1.0"

  s.add_development_dependency "rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "test-unit"
end
