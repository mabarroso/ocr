require 'soap/wsdlDriver'
require 'base64'


module OCR
  class Free_ocr < OCR::Ocr

    attr_accessor :convert_to_bw

    private
    def init
      super()
    end

    def ocr_recognize
      raise Exception, 'You should set image file' unless @file
#      request = {
#        'image' => File.open(@file, 'rb') { |f| [f.read].pack('m*') }
#      }
#puts request
#return
      #client = Savon::Client.new('http://www.free-ocr.co.uk/ocr.asmx?WSDL')
#puts client.wsdl.soap_actions
#return
      #begin
      #  response = client.request(:analyze) do
      #    soap.body = request
      #  end
      #rescue
      #  puts "EX"
      #end

client = SOAP::WSDLDriverFactory.new( 'http://www.free-ocr.co.uk/ocr.asmx?WSDL' ).create_rpc_driver
result = client.analyze(:image => File.open(@file, 'rb') { |f| [f.read].pack('m*') })

puts response. analyzeResult

puts result
return

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