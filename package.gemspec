Gem::Specification.new do |s|
  s.name = 'rails_extend'
  s.version = '1.0.1'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.summary = 'Rails Engine with common utils'
  s.description = 'Common utils for Rails Application'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'Rakefile',
    'LICENSE',
    'README.md'
  ]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 5.0'
end
