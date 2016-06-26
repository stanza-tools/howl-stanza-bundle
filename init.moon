-- Copyright 2016 Jake Russo
-- License: MIT

mode_reg =
  name: 'stanza'
  extensions: {
    'stz,'
    'stanza'
  }
  create: -> bundle_load('stanza_mode')

howl.mode.register mode_reg

unload = -> howl.mode.unregister 'stanza'

{
  info:
    author: 'Jake Russo'
    description: 'Stanza mode',
    license: 'MIT',
  :unload
}
