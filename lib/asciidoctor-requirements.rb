RUBY_ENGINE == 'opal' ? (require 'asciidoctor-requirements/extension') : (require_relative 'asciidoctor-requirements/extension')

# Register the extensions to asciidoctor
Asciidoctor::Extensions.register do
    block AsciidoctorRequirements::Asciidoctor::RequirementBlock
  end