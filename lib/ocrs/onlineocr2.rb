require 'net/http'
require 'base64'


module OCR
  class Onlineocr2 < OCR::Ocr

    attr_accessor :convert_to_bw

    private
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
        'OCRWSSettings' => {
#          'ocrLanguages' => [self.language.to_s.upcase],
          'outputDocumentFormat' => self.format.to_s.upcase,
          'convertToBW' => self.convert_to_bw,
          'getOCRText' => true,
          'createOutputDocument' => false,
          'multiPageDoc' => false,
          'ocrWords' => true
        },
        'OCRWSInputImage' => {
          'fileName' => File.basename(@file),
#          'fileData' => File.open(@file, 'rb') { |f| [f.read].pack('m*') }
        },
      }
#puts request
#return
      data =<<EOT
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Body>
            <OCRWebServiceRecognize xmlns="http://stockservice.contoso.com/wse/samples/2005/10">
              <user_name>#{@username}</user_name>
              <license_code>#{@password}</license_code>
              <OCRWSInputImage>
                <fileName>string</fileName>
                <fileData>base64Binary</fileData>
              </OCRWSInputImage>
              <OCRWSSetting>
                <ocrLanguages>#{self.language.to_s.upcase}</ocrLanguages>
                <outputDocumentFormat>#{self.format.to_s.upcase}</outputDocumentFormat>
                <convertToBW>#{self.convert_to_bw}</convertToBW>
                <getOCRText>true</getOCRText>
                <createOutputDocument>false</createOutputDocument>
                <multiPageDoc>false</multiPageDoc>
                <ocrWords>true</ocrWords>
              </OCRWSSetting>
            </OCRWebServiceRecognize>
          </soap:Body>
        </soap:Envelope>
EOT

      headers = {
         'Host' => 'www.ocrwebservice.com',
         'Content-Type' => 'application/soap+xml; charset=utf-8',
#         'Content-Type' => 'text/xml',
         'Content-Length' => "#{data.length}",
         'SOAPAction' => '"http://stockservice.contoso.com/wse/samples/2005/10/OCRWebServiceRecognize"'
      }

      host = 'www.ocrwebservice.com'
      url = '/services/OCRWebService.asmx'

#data = data.squeeze.tr "\n", ''
puts data
puts headers

#return
      http = Net::HTTP.new(host, 80)
      http.use_ssl = false
      resp = http.post(url, data, headers)

puts resp
puts 'Code = ' + resp.code
puts 'Message = ' + resp.message



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