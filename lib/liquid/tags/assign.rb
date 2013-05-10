module Liquid

  # Assign sets a variable in your template.
  #
  #   {% assign foo = 'monkey' %}
  #
  # You can then use the variable later in the page.
  #
  #  {{ foo }}
  #
  class Assign < Tag
    Syntax = /(#{VariableSignature}+)\s*=\s*(.*)\s*/o
  
    def initialize(tag_name, markup, tokens)          
      if markup =~ Syntax
        @to = $1
        @from = Variable.new($2)
      else
        message = "Syntax Error in 'assign' - Valid syntax: assign [var] = [source]"
        raise SyntaxError.new(message, tokens.next_token)
      end
      
      super      
    end
  
    def render(context)
       context.scopes.last[@to] = @from.render(context)
       ''
    end 
  
  end  
  
  Template.register_tag('assign', Assign)  
end
