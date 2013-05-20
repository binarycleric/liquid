module Liquid
  class Case < Block
    Syntax     = /(#{QuotedFragment})/o
    WhenSyntax = /(#{QuotedFragment})(?:(?:\s+or\s+|\s*\,\s*)(#{QuotedFragment}.*))?/o

    def initialize(tag_name, markup, tokens)      
      @blocks = []
      
      if markup =~ Syntax
        @left = $1
      else
        message = "Syntax Error in tag 'case' - Valid syntax: case [condition]"
        raise SyntaxError.new(message, tokens)
      end
            
      super
    end

    def unknown_tag(tag, markup, tokens)
      @nodelist = []
      case tag
      when 'when'
        record_when_condition(markup, tokens)
      when 'else'
        record_else_condition(markup, tokens)
      else
        super
      end
    end

    def render(context)      
      context.stack do          
        execute_else_block = true
        
        output = ''
        @blocks.each do |block|
          if block.else? 
            return render_all(block.attachment, context) if execute_else_block
          elsif block.evaluate(context)
            execute_else_block = false        
            output << render_all(block.attachment, context)
          end            
        end
        output
      end          
    end
    
    private
    
    def record_when_condition(markup, tokens)                
      while markup
      	# Create a new nodelist and assign it to the new block
      	if not markup =~ WhenSyntax
          message = "Syntax Error in tag 'case' - Valid when condition: {% when [condition] [or condition2...] %} "
      	  raise SyntaxError.new(message, tokens)
      	end

      	markup = $2

      	block = Condition.new(@left, '==', $1)        
      	block.attach(@nodelist)
      	@blocks.push(block)
      end
    end

    def record_else_condition(markup, tokens)            

      if not markup.strip.empty?
        message = "Syntax Error in tag 'case' - Valid else condition: {% else %} (no parameters) "
        raise SyntaxError.new(message, tokens)
      end
         
      block = ElseCondition.new            
      block.attach(@nodelist)
      @blocks << block
    end
    
        
  end    
  
  Template.register_tag('case', Case)
end
