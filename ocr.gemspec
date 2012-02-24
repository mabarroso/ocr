$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ocr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "OCR"
  s.version     = OCR::VERSION
  s.authors     = ["Miguel Adolfo Barroso"]
  s.email       = ["mabarroso@mabarroso.com"]
  s.homepage    = "https://github.com/mabarroso/ocr"
  s.summary     = "OCR web services gateway for Ruby."
  s.description = "Recognize text and characters from image files using web services."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency "rspec", "~> 2.7.0"
end
