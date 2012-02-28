require File.expand_path('../ocr/factory', __FILE__)
require File.expand_path('../ocr/ocr', __FILE__)
require File.expand_path('../ocrs/dummy', __FILE__)
require File.expand_path('../ocrs/weocr', __FILE__)
require File.expand_path('../ocrs/onlineocr', __FILE__)
require File.expand_path('../ocrs/free_ocr', __FILE__)


module OCR
  def self.use name
    Factory.create eval name.to_s.capitalize
  end
end