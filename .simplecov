SimpleCov.start do
  add_group 'Commands', 'lib/commands'
  add_group 'Contracts', 'lib/contracts'
  add_group 'Entities', 'lib/entities'
  add_group 'Relations', 'lib/persistence/relations'
  add_group 'Repos', 'lib/repos'
  add_group 'Services', 'lib/services'

  add_filter '/spec/'
end
