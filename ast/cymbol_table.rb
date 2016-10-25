class CymbolTable
  attr_accessor :cymbols

  def initialize
    self.cymbols = Hash[]
    init_builtins
  end

  def init_builtins
    define(BuiltinTypeCymbol.new('INTEGER'))
    define(BuiltinTypeCymbol.new('REAL'))
  end

  def to_s
    "Cymbols: #{cymbols.map { |_k, v| v.to_s }}"
  end

  def define(cymbol)
    puts "Define: #{cymbol}"
    cymbols[cymbol.name] = cymbol
  end

  def lookup(name)
    puts "Lookup: #{name}"
    cymbols[name]
  end
end
