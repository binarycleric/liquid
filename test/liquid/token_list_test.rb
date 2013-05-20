require 'test_helper'

class TokenListTest < Test::Unit::TestCase
  include Liquid

  def test_tokenize_strings
    assert_equal ' ', TokenList.new(' ').next_token!
    assert_equal 'hello world', TokenList.new('hello world').next_token!
  end

  def test_tokenize_variables
    assert_equal "{{funk}}", TokenList.new('{{funk}}').next_token! 

    token_list = TokenList.new(" {{funk}} ")
    tokens = []
    until token_list.empty? do tokens << token_list.next_token! end
    assert_equal [' ', '{{funk}}', ' '], tokens 

    token_list = TokenList.new(" {{funk}} {{so}} {{brother}} ") 
    tokens = []
    until token_list.empty? do tokens << token_list.next_token! end
    assert_equal [' ', '{{funk}}', ' ', '{{so}}', ' ', '{{brother}}', ' '], tokens
  end

  def test_tokenize_blocks
    assert_equal "{%comment%}", TokenList.new("{%comment%}").next_token!

    token_list = TokenList.new(" {%comment%} ")
    tokens = []
    until token_list.empty? do tokens << token_list.next_token! end
    assert_equal [' ', '{%comment%}', ' '], tokens 

    token_list = TokenList.new(" {%comment%} {%endcomment%} ") 
    tokens = []
    until token_list.empty? do tokens << token_list.next_token! end
    assert_equal [' ', '{%comment%}', ' ', '{%endcomment%}', ' '], tokens

    token_list = TokenList.new(" {% comment %} {% endcomment %} ") 
    tokens = []
    until token_list.empty? do tokens << token_list.next_token! end
    assert_equal [' ', '{% comment %}', ' ', '{% endcomment %}', ' '], tokens
  end

  def test_line_number
    source =<<EOF
Hello world
{% if true %}
  HELLO
{% endif %}
EOF

    tokens = TokenList.new(source)
    expected = [1, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5]

    expected.each do |i|
      token = tokens.next_token!
      assert_equal(i, tokens.last_line_number)
    end

    assert tokens.empty?
  end

  def test_line_number_with_tricky_code
    source =<<EOF
{% if true %}{% for item in collection %}
  I'm here.
{% endfor %}{% endif %}
EOF

    tokens = TokenList.new(source)
    expected = [1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 3, 3, 4]

    expected.each do |i|
      token = tokens.next_token!
      assert_equal(i, tokens.last_line_number)
    end

    assert tokens.empty?
  end

end
