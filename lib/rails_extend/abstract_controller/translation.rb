# frozen_string_literal: true

module RailsExtend::AbstractController
  module Translation

    def translate(key, **options)
      if key&.start_with('..')
        binding.b
      end

      super
    end

  end
end

AbstractController::Translation.prepend RailsExtend::AbstractController::Translation
