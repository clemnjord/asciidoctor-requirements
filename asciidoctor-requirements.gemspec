begin
  require_relative "lib/asciidoctor-requirements/version"
rescue LoadError
  require 'asciidoctor-requirements/version'
end

Gem::Specification.new do |spec|
  spec.name = "asciidoctor-requirements"
  spec.version = AsciidoctorRequirements::VERSION
  spec.authors = ["clemnjord"]
  spec.homepage = "https://github.com/clemnjord/asciidoctor-requirements"
  spec.summary = "An asciidoctor extension that transforms a yaml block in a formatted requirement."
  spec.license = "MIT"
  spec.description = "An asciidoctor extension that transforms a yaml block in a formatted requirement."
  spec.required_ruby_version = ">= 2.6.0"
  spec.files = Dir['lib/**/*'] + ['README.adoc']
  
  spec.add_runtime_dependency 'asciidoctor', '~> 2.0', '>= 2.0.20'
  spec.add_runtime_dependency  'yaml', '~> 0.2.1'

  spec.add_development_dependency 'asciidoctor-pdf', '~> 2.3', '>= 2.3.8'
  spec.add_development_dependency 'asciidoctor-diagram', '~> 2.2'
end



