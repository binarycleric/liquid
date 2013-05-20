module Liquid
  class Error < ::StandardError; end
  
  class ArgumentError < Error; end
  class ContextError < Error; end
  class FilterNotFound < Error; end
  class FileSystemError < Error; end
  class StandardError < Error; end

  class SyntaxError < Error

    attr_reader :line_number

    def initialize(msg, tokens=nil) # line_number=nil)
      if tokens
        @line_number = tokens.last_line_number 
        @tokens = tokens.dup
      end

      super(msg)
    end

    # To not break prod (WebKite) ~Jon
    def liquid_line_number
      @line_number
    end

  end

  class StackLevelError < Error; end
end
