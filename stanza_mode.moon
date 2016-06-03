-- Copyright 2016 Jake Russo
-- License: MIT

{
  lexer: bundle_load('stanza_lexer')

  comment_syntax: ';'

  default_config:
    word_pattern: r'[^ %t0-9~!@#$%%^*+-=/.:&|<>][^ %t,.:&|<>%[%]{}()]*'
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
      l\match('^%s*.-%s*defstruct.-:') or l\match('^%s*.-%s*deftype.-:')]
}
