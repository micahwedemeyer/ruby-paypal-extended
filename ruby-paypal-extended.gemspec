require 'rake'

Gem::Specification.new do |s|
  s.name = "ruby-paypal-extended"
  s.version = "0.5"
  s.authors = ["Micah Wedemeyer"]
  s.date = "2009-05-10"
  s.summary = "A library for interfacing with PayPal." 
  s.description = "ruby-paypal-extended is a Ruby library for interacting with PayPal via the NVP (Name Value Pair) REST interface."
  s.email = "micah@aisleten.com"
  s.homepage = "http://github.com/MicahWedemeyer/ruby-paypal-extended"
  s.files = FileList['lib/**/*.rb', 'licenses/*', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
  s.has_rdoc = true
end
