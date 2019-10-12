Gem::Specification.new do |s|
  s.name        = 'rcurtain'
  s.version     = '0.0.7'
  s.date        = '2017-07-03'
  s.summary     = "RCurtain"
  s.description = "Open the curtain and see if your feature is enabled"
  s.authors     = ["Danillo Souza", "Gabriel Queiroz", "Guilherme Sipoloni"]
  s.email       = ["danillo.souza@moip.com.br", "gabriel.queiroz@moip.com.br", "guilehrme.sipoloni@moip.com.br"]
  s.homepage    = 'http://github.com/moip/rcurtain'
  s.license     = 'MIT'

  s.files       = Dir['**/*'].keep_if { |file| File.file?(file) }
  s.require_paths = ['lib']

  s.add_runtime_dependency "hiredis"
  s.add_runtime_dependency "redis", "~>3.2"
  s.add_development_dependency 'fakeredis'
  s.add_development_dependency "rspec"
  s.add_development_dependency "pry-byebug"
end
