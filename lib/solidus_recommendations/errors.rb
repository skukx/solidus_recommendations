module SolidusRecommendations
  module Errors
    class Standard < StandardError
      def initialize(msg = MESSAGES[self.class])
      end
    end

    class NonSupportedIndex < Standard; end

    MESSAGES = {
      NonSupportedIndex => 'The index specified is not supported.'
    }
  end
end
