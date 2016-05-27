Gem::Specification.new do |s|
  s.name        = 'rcurtain'
  s.version     = '0.0.1'
  s.date        = '2016-05-26'
  s.summary     = "RCurtain"
  s.description = "Open the curtain and see if your feature is enabled"
  s.authors     = ["Danillo Souza", "Gabriel Queiroz"]
  s.email       = ["danillo.souza@moip.com.br", "gabriel.queiroz@moip.com.br"]
  s.files       = ["lib/rcurtain.rb"]
  s.homepage    =
    'http://github.com/moip/curtain'
  s.license       = 'MIT'

  s.add_runtime_dependency "hiredis"
  s.add_runtime_dependency "redis", "~>3.2"
  s.add_development_dependency "rspec"
end
