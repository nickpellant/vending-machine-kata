# frozen_string_literal: true

module Commands
  class ApplicationCommand
    extend Dry::Initializer

    def self.call(**args)
      new(**args).call
    end
  end
end
