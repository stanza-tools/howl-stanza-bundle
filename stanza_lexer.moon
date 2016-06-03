-- Copyright 2016 Jake Russo
-- License: MIT


howl.aux.lpeg_lexer ->

  word = (...) ->
    word_char = alpha + digit + S'_-+?!'
    (-B(1) + B(-word_char)) * any(...) * -word_char

  c = capture

  ident_filler = (alpha + digit + S'_-+?!')^0
  ident = (alpha + S'$#')^1 * ident_filler
  ws = c 'whitespace', blank

  identifier = c 'identifier', ident

  fdecl = c('keyword', word { 'defn', 'defmulti', 'defmethod' }) *
    (c 'operator', '*')^0 * ws^1 * c('type_def', ident) * ws^1
  decl = c('keyword', word {'defstruct', 'defpackage', 'deftype'}) * ws^1 * c('label', ident)

  keyword = c 'keyword', word {
    'if', 'else', 'when', 'switch', 'match', 'let', 'let-var',
   'where', 'for', 'while', 'label', 'yield', 'try', 'catch',
   'finally', 'throw', 'attempt', 'fn', 'fn*', 'multifn', 'multifn*',
   'qquote', 'return', 'call-c', 'val', 'var', 'import', 'with'
  }

  declarator = c 'member', word {
    'val', 'var', 'label', 'let', 'let-var', 'new'
  }

  functions = c 'function', word {
    'not-equal', 'not-equal?', 'equal', 'equal?', 'compare',
    'less?', 'less-eq?', 'greater?', 'greater-eq?', 'to-seq',
    'maximum', 'max', 'minimum', 'min', 'hash', 'length', 'push',
    'empty?', 'next', 'peek', 'get?', 'get', 'set', 'map!', 'map',
    'reverse!', 'reverse', 'in-reverse', 'println-all', 'println', 'print-all', 'print',
    'with-output-stream', 'current-output-stream', 'get-char', 'get-byte',
    'do-indented', 'indented', 'put', 'close', 'with-output-file', 'spit',
    'write-all', 'write', 'close', 'slurp', 'peek?', 'info',
    'bits-as-float', 'bits-as-double', 'bits', 'rand', 'fill-template', 'fill',
    'ceil-log2', 'floor-log2', 'next-pow2', 'prev-pow2', 'sum', 'product',
    'complement', 'digit?', 'letter?', 'upper-case?', 'upper-case',
    'lower-case?', 'lower-case', 'start', 'end', 'step', 'inclusive?', 'to-string',
    'matches?', 'prefix?', 'suffix?', 'append-all', 'append',
    'string-join', 'last-index-of-chars', 'last-index-of-char', 'replace', 'trim',
    'add-all', 'add', 'clear', 'to-array', 'get-chars', 'set-chars',
    'to-tuple', 'cons', 'to-list', 'head', 'headn', 'tail', 'tailn',
    'but-last', 'last', 'transpose', 'seq-append', 'filename', 'line', 'column',
    'item', 'unwrap-token', 'unwrap-all', 'key?', 'keys?', 'key', 'value?', 'value!', 'values', 'value',
    'to-symbol', 'symbol-join', 'gensym', 'name', 'id', 'qualified?', 'qualifier',
    'throw', 'with-exception-handler', 'with-finally', 'try-catch-finally',
    'fatal', 'fail', 'with-attempt', 'attempt-else', 'generate',
    'resume', 'suspend', 'break', 'close', 'active?', 'open?',
    'dynamic-wind', 'find!', 'find', 'first!', 'first', 'seq?', 'seq', 'filter',
    'index-when!', 'index-when', 'split', 'take-while', 'take-until', 'seq-cat',
    'all?', 'none?', 'any?', 'count', 'repeat_while', 'repeat', 'repeatedly',
    'take-n', 'take-up-to-n', 'cat-all', 'cat', 'join', 'zip-all', 'zip',
    'contains?', 'index-of!', 'index-of', 'reduce-right', 'reduce', 'unique',
    'lookup??', 'parallel-seq', 'qsort!', 'lazy-qsort', 'marker!', 'marker',
    'add-gc-notifier', 'command-line-arguments', 'file-exists?',
    'delete-file', 'resolve-path', 'current-time-ms', 'current-time-us',
    'get-env', 'set-env', 'call-system', 'stop', 'time',
    'exp', 'log10', 'log', 'pow', 'sin', 'cos', 'tan', 'asin', 'acos', 'atan', 'atan2',
    'sinh', 'cosh', 'tanh', 'ceil', 'floor', 'round', 'to-radians', 'to-degrees',
    'to-vector', 'pop', 'peek', 'remove-item', 'remove-when', 'remove', 'update', 'shorten',
    'lengthen', 'default?', 'read-file', 'read-all', 'read', 'tagged-list?'
  }

  constant = c 'constant', word { 'true', 'false', 'this' }

  lotypes = c 'type', upper * ident_filler

  uniqtypes = c 'special', (word { 'ref', 'ptr' }) + (-B'%w' * '?')

  lostanza = c 'type', word { 'byte', 'int', 'long', 'float', 'double' }

  modifier = c 'special', word { 'public', 'protected', 'extern', 'lostanza' }

  wordop = c 'operator', word {
    'to', 'through', 'by', 'in', 'and', 'or', 'not',
    'as', 'as?', 'is', 'do', 'seq'
  }

  operator = c 'operator', S'~!@#$%^*+-=/.:&|<>'^1

  comment = c 'comment', P';' * scan_until eol

  number = c 'number', digit * scan_until(ws + S'()[]{}' + operator)

  char = c 'char', P"'" * (P'\\' * P(1) + P(1)) * P"'"

  P {
    'all'

    all: any {
      comment,
      V'string',
      V'deref',
      char,
      number,
      declarator,
      wordop,
      lostanza,
      modifier,
      fdecl,
      decl,
      keyword,
      functions,
      constant,
      lotypes,
      uniqtypes,
      operator
      identifier,
    }

    string: sequence {
      c('string', '"'),
      V'string_chunk',
      c('string', '"')
    }

    string_chunk: c('string', scan_until(any('"', '%'), '\\')) * any {
      #P('"'),
      V'interpolation' * V'string_chunk',
      c('string', P(1)) * V'string_chunk'
    }

    interpolation: c 'operator', P'%' * S'_*,~@%'

    deref: sequence {
      c('special', B(eol + blank) * '['),
      V'all',
      c('special', ']')
    }

  }
