require 'savon'
require 'base64'


module OCR
  class Onlineocr < OCR::Ocr

    attr_accessor :convert_to_bw

    private
    WSDL = 'http://www.ocrwebservice.com/services/OCRWebService.asmx?WSDL'

    def init
      super()
      self.language= :english
      self.format= :txt
      self.convert_to_bw= false
    end

    def ocr_recognize
      raise Exception, 'You should set username and license as password' unless @username && @password
      request = {
        'user_name' => @username,
        'license_code' => @password,
        'OCRWSInputImage' => {
          'fileName' => File.basename(@file),
#          'fileData' => File.open(@file, 'rb') { |f| [f.read].pack('m*') }
        },
        'OCRWSSettings' => {
          'ocrLanguages' => [self.language.to_s.upcase],
          'outputDocumentFormat' => self.format.to_s.upcase,
          'convertToBW' => self.convert_to_bw,
          'getOCRText' => true,
          'createOutputDocument' => false,
          'multiPageDoc' => false,
          'ocrWords' => true
        }
      }
#puts request
#return
      client = Savon::Client.new(WSDL)
      response = client.request(:ocr_web_service_recognize) do
        soap.body = request
      end
puts
puts "BODY: #{response.body}"

      return false if have_error? response.body
puts 'sigue'
      set_text !response[:ocr_text].nil? ? response[:ocr_text] : ''
    end

    def have_error? response
      return true && set_error("No response") unless response.has_key?(:ocr_web_service_recognize_response)
      return true && set_error("No response") unless response[:ocr_web_service_recognize_response].has_key?(:ocrws_response)
      return true && set_error("No response") unless response[:ocr_web_service_recognize_response].has_key?(:ocrws_response)
      return false if response[:ocr_web_service_recognize_response][:ocrws_response][:error_message].nil?
      set_error response[:ocr_web_service_recognize_response][:ocrws_response][:error_message]
      true
    end
  end
end