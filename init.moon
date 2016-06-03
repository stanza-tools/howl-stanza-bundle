-- Copyright 2016 Jake Russo
-- License: MIT

howl.mode.register
  name: 'stanza'
  extensions: {
    'stz,'
    'stanza'
  }
  -- shebangs: '[/ ]stanza.*$'
  create: -> bundle_load 'stanza_mode'

unload = -> howl.mode.unregister 'stanza'

{
  info:
    author: 'The Howl Developers'
    description: 'A Stanza bundle',
    license: 'MIT',
  :unload
}
