root = File.expand_path('../..', __FILE__)
require File.join(root, %w[lib ocr])

describe OCR do
  it "should be correct size" do
  	OCR.use :dummy
  end
end
