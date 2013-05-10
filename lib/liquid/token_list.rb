module Liquid

  class Token < String

    attr_reader :line_number

    def initialize(token, line_number)
      @token = token
      @line_number = line_number

      super(@token)
    end

  end

  ##
  # Tokenizer capable of determining the line number of the most recently
  # returned token. Can be useful for giving the user more meaningful feedback
  # when they make a mistake.
  class TokenList

    attr_reader :line_number

    def initialize(source)
      source = source.source if source.respond_to?(:source)
      # @source = source
      @tokens = tokenize(source)
    end

    ##
    # Gets the next token and removes it from the stack.
    def next_token!
      @tokens.shift
    end

    ##
    # Gets the next token without removing it from the stack.
    def next_token
      @tokens.first
    end

    ##
    # Alias for #next_token!
    def shift
      next_token!
    end

    def empty?
      @tokens.empty?
    end

    private

    # Uses the <tt>Liquid::TemplateParser</tt> regexp to tokenize the passed source
    def tokenize(source)
      return [] if source.to_s.empty?
      tokens = source.split(TemplateParser)

      # removes the rogue empty element at the beginning of the array
      tokens.shift if tokens[0] and tokens[0].empty?

      tokens.each_with_index.map do |raw, i|
        line_number = tokens[0..i].join("").scan(/\r\n|\n|\r/).size +  1
        Token.new(raw, line_number)
      end
    end

  end

end
