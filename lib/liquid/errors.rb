module Liquid
  class Error < ::StandardError; end
  
  class ArgumentError < Error; end
  class ContextError < Error; end
  class FilterNotFound < Error; end
  class FileSystemError < Error; end
  class StandardError < Error; end

  class SyntaxError < Error

    attr_reader :token

    def initialize(msg, token=nil)
      @token = token
      super(msg)
    end
 
    def liquid_line_number
      return nil unless @token
      return @token.line_number
    end

  end

  class StackLevelError < Error; end
end
