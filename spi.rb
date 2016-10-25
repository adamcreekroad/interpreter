require 'readline'
require 'pry'
require_relative 'cymbol'
require_relative 'cymbol/builtin_type_cymbol'
require_relative 'cymbol/var_cymbol'
require_relative 'ast'
require_relative 'ast/assign'
require_relative 'ast/bin_op'
require_relative 'ast/block'
require_relative 'ast/compound'
require_relative 'ast/cymbol_table'
require_relative 'ast/no_op'
require_relative 'ast/num'
require_relative 'ast/program'
require_relative 'ast/type'
require_relative 'ast/unary_op'
require_relative 'ast/var_decl'
require_relative 'ast/var'
require_relative 'lexer'
require_relative 'node_visitor'
require_relative 'node_visitor/interpreter'
require_relative 'node_visitor/cymbol_table_builder'
require_relative 'parser'
require_relative 'token'

INTEGER       = 'INTEGER'
REAL          = 'REAL'
INTEGER_CONST = 'INTEGER_CONST'
REAL_CONST    = 'REAL_CONST'
PLUS          = 'PLUS'
MINUS         = 'MINUS'
MUL           = 'MUL'
INTEGER_DIV   = 'INTEGER_DIV'
FLOAT_DIV     = 'FLOAT_DIV'
PAREN         = 'PAREN'
ID            = 'ID'
ASSIGN        = 'ASSIGN'
P_BEGIN       = 'BEGIN'
P_END         = 'END'
SEMI          = 'SEMI'
DOT           = 'DOT'
PROGRAM       = 'PROGRAM'
VAR           = 'VAR'
COLON         = 'COLON'
COMMA         = 'COMMA'
EOF           = 'EOF'

RESERVED_KEYWORDS = {
  program: Token.new('PROGRAM', 'PROGRAM'),
  var:     Token.new('VAR', 'VAR'),
  div:     Token.new('INTEGER_DIV', 'DIV'),
  integer: Token.new('INTEGER', 'INTEGER'),
  real:    Token.new('REAL', 'REAL'),
  begin:   Token.new('BEGIN', 'BEGIN'),
  end:     Token.new('END', 'END')
}

def main(file_name)
  text = File.read(file_name)
  lexer = Lexer.new(text)
  parser = Parser.new(lexer)
  tree = parser.parse
  cymtab_builder = CymbolTableBuilder.new
  cymtab_builder.visit(tree)
  print "\n"
  print "Symbol Table contents:\n"
  print cymtab_builder.cymbol_table
  print "\n"

  lexer = Lexer.new(text)
  parser = Parser.new(lexer)
  interpreter = Interpreter.new(parser)
  _result = interpreter.interpret

  print "\n"
  print "Run-time GLOBAL_MEMORY contents:\n"
  Interpreter::GLOBAL_SCOPE.each do |k, v|
    print "#{k} = #{v}\n"
  end
end

main(ARGV[0]) if ARGV[0]
