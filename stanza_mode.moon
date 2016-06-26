-- Copyright 2016 Jake Russo
-- License: MIT

{
  lexer: bundle_load('stanza_lexer')
  -- api: bundle_load('api')
  -- completers: { 'in_buffer', 'api' }

  comment_syntax: ';'

  default_config:
    indent: 3

  indentation: {
    more_after: {
      ':%s*$',
      '[[{(]%s*$'
    }

    less_for: {
      '^%s*else%s*:%s*$',
      '^%s*else%s+if%s+.-:%s*$',
      r'^\\s*[\\]}\\)]'
    }
  }

  auto_pairs: {
    '(': ')'
    '[': ']'
    '{': '}'
    "'": "'"
    '"': '"'
  }

  structure: (editor) =>
    [l for l in *editor.buffer.lines when l\match('^%s*.-%s*defn%s') or
      l\match('^%s*.-%s*defstruct%s') or
      l\match('^%s*.-%s*deftype%s') or
      l\match('^%s*.-%s*defmethod%s') or
      l\match('^%s*.-%s*defpackage%s') or
      l\match('^%s*.-%s*defmulti%s')]
}
