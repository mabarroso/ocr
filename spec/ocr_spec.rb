# encoding: utf-8

root = File.expand_path('../..', __FILE__)
require File.join(root, %w[lib ocr])

describe Ocr::Ocr do
  it "should be correct size" do
  	Ocr::Ocr.new
  end
end
