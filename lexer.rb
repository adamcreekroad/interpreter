require_relative 'token'

class Lexer
  def initialize(text)
    @text = text
    @pos = 0
    @current_char = @text[@pos]
  end

  def skip_comment
    advance while @current_char != '}'
    advance
  end

  def _id
    result = ''
    while @current_char && alphanum? || @current_char == '_'
      result += @current_char
      advance
    end
    RESERVED_KEYWORDS[result.downcase.to_sym] || Token.new(ID, result)
  end

  def peek
    peek_pos = @pos + 1
    return if peek_pos > @text.length - 1
    @text[peek_pos]
  end

  def advance
    @pos += 1
    @current_char = @pos > (@text.length - 1) ? nil : @text[@pos]
  end

  def skip_whitespace
    advance while @current_char && space?
  end

  def space?
    [' ', "\n"].include?(@current_char)
  end

  def alpha?
    @current_char.scan(/^[[:alpha:]]$/).any?
  end

  def alphanum?
    @current_char.scan(/^([[:alpha:]]|[[:digit:]])$/).any?
  end

  def integer?
    @current_char == '0' || @current_char != '0' && !@current_char.to_i.zero?
  end

  def integer
    result = ''
    while @current_char && integer?
      result += @current_char
      advance
    end
    Integer(result)
  end

  def number
    result = ''
    while @current_char && integer?
      result += @current_char
      advance
    end
    if @current_char == '.'
      result += @current_char
      advance
      while @current_char && integer?
        result += @current_char
        advance
      end
      Token.new('REAL_CONST', Float(result))
    else
      Token.new('INTEGER_CONST', Integer(result))
    end
  end

  def operator?
    ['+', '-', '*', '/'].include?(@current_char)
  end

  def operator
    case @current_char
    when '+' then PLUS
    when '-' then MINUS
    when '*' then MUL
    when '/' then FLOAT_DIV
    end
  end

  def paren?
    ['(', ')'].include?(@current_char)
  end

  def next_token
    while @current_char
      if space?
        skip_whitespace
      elsif @current_char == '{'
        advance
        skip_comment
      elsif alpha? || @current_char == '_'
        return _id
      elsif integer?
        return number
      elsif @current_char == ':' && peek == '='
        advance
        advance
        return Token.new(ASSIGN, ':=')
      elsif @current_char == ';'
        advance
        return Token.new(SEMI, ';')
      elsif @current_char == ':'
        advance
        return Token.new(COLON, ':')
      elsif @current_char == ','
        advance
        return Token.new(COMMA, ',')
      elsif operator?
        token = Token.new(operator, @current_char)
        advance
        return token
      elsif paren?
        token = Token.new(PAREN, @current_char)
        advance
        return token
      elsif @current_char == '.'
        advance
        return Token.new(DOT, '.')
      else
        raise LexError, %(Invalid character "#{@current_char}")
      end
    end
    Token.new(EOF, nil)
  end
end

class LexError < StandardError
end
