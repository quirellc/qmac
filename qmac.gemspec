Gem::Specification.new do |spec|
  # Required Fields
  spec.authors = ['Ryan Jansen']
  spec.files = Dir['lib/*.rb'] + Dir['lib/qmac/*.rb']
  spec.name = 'qmac'
  spec.summary = 'Library for signing and verifying HTTPS requests.'
  spec.version = '0.1.0'

  # dependencies
  spec.add_runtime_dependency 'connection_pool', '~> 2.2', '>= 2.2.0'
  spec.add_runtime_dependency 'redis', '~> 3.2', '>= 3.2.1'
  spec.required_ruby_version = '>=2.1.5'

  # Optional fields
  spec.date = '2019-09-24'
  spec.description = 'This GEM provides a pluggable framework for signing and verifying requests using HMAC and private keys.'
end
