Gem::Specification.new do |s|
  s.name = 'rails_extend'
  s.version = '1.0.0'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_extend'
  s.summary = 'Rails Engine with common utils'
  s.description = 'Common utils for Rails Application'
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'Rakefile',
    'LICENSE',
    'README.md'
  ]
  s.require_paths = ['lib']

  s.add_dependency 'rails', '>= 6.0'
end
