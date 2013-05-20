module Liquid

  ##
  # Tokenizer capable of determining the line number of the most recently
  # returned token. Can be useful for giving the user more meaningful feedback
  # when they make a mistake.
  class TokenList

    def initialize(source)
      source = source.source if source.respond_to?(:source)
      # @source = source
      
      @token_pointer = 0
      @tokens = tokenize(source)
    end

    ##
    # Gets the next token and removes it from the stack.
    def next_token!
      token = @tokens[@token_pointer]
      @token_pointer += 1
      return token
    end

    ##
    # Gets the next token without removing it from the stack.
    def next_token
      @tokens[@token_pointer]
    end

    ##
    # Gets the line number of the last returned token.
    def last_line_number
      line_number = 1
      @tokens[0..@token_pointer-1].each do |token, i|
         line_number += token.scan(/\r\n|\n|\r/).size
      end
      return line_number
    end

    ##
    # Assuming a nil value is the end of the token array.
    def empty?
      @tokens[@token_pointer].nil?
    end

    private

    # Uses the <tt>Liquid::TemplateParser</tt> regexp to tokenize the passed source
    def tokenize(source)
      return [] if source.to_s.empty?
      tokens = source.split(TemplateParser)

      # removes the rogue empty element at the beginning of the array
      tokens.shift if tokens[0] and tokens[0].empty?

      return tokens
    end

  end

end
