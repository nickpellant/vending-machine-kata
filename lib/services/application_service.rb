# frozen_string_literal: true

module Services
  class ApplicationService
    extend Dry::Initializer

    def self.call(**args)
      new(**args).call
    end
  end
end
