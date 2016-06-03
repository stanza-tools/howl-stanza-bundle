{
  whitelist_globals: {
    [".+%.moon"]: {
      "howl", "bundle_load"
    }
    ["stanza_lexer%.moon"]: {
      "any", "alpha", "capture", "blank", "digit", "word", "S", "scan_until",
      "eol", "P", 'r', 'R', 'B', 'span', 'upper', 'sequence', 'V'
    }
    ["stanza_mode%.moon"]: {
      'r'
    }
  }
}
