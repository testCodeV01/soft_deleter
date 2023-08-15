require_relative "lib/soft_deleter/version"

Gem::Specification.new do |spec|
  spec.name        = "soft_deleter"
  spec.version     = SoftDeleter::VERSION
  spec.authors     = ["testCodeV01"]
  spec.email       = ["qft-tk-1213@tk-labo.com"]
  spec.homepage    = "https://github.com/testCodeV01"
  spec.summary     = "SoftDeleter."
  spec.description = "SoftDeleter."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://github.com/testCodeV01/soft_deleter.git"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/testCodeV01/soft_deleter"
  spec.metadata["changelog_uri"] = "https://github.com/testCodeV01"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.7"
  spec.add_dependency "rspec-rails"
end
