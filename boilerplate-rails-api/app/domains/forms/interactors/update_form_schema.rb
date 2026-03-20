module Forms
  module Interactors
    class UpdateFormSchema
      def initialize(repo: Forms::Repositories::FormSchemaRepository.new)
        @repo = repo
      end
      def call(slug, attrs)
        current = @repo.find_by_slug(slug) || Forms::Entities::FormSchema.new(slug: slug)
        merged = { slug: current.slug || slug, title: attrs[:title] || current.title, submit_label: attrs[:submit_label] || current.submit_label || "Submit", submit_endpoint: attrs[:submit_endpoint] || current.submit_endpoint, submit_method: attrs[:submit_method] || current.submit_method || "POST", fields: attrs[:fields] || current.fields, active: attrs.key?(:active) ? attrs[:active] : current.active }
        schema = Forms::Entities::FormSchema.new(merged)
        raise Forms::Errors::InvalidSchema, schema.errors.join(", ") unless schema.valid?
        @repo.update(slug, attrs)
      end
    end
  end
end
