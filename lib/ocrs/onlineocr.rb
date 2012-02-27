require 'savon'

module OCR
  class Onlineocr < OCR::Ocr

    attr_accessor :convert_to_bw, :multi_page_doc

    private
    def init
      super()
      self.language= :english
      self.format= :txt
      self.convert_to_bw= false
      self.multi_page_doc= false
    end

    def ocr_recognize
      raise Exception, 'You should set username and license as password' unless @username && @password
      request = {
        'user_name' => @username,
        'license_code' => @password,
        'OCRWSInputImage' => {
          'fileName' => File.basename(@file),
          'fileData' => File.open(@file, 'rb') { |f| [f.read].pack('m*') }
        },
        'OCRWSSetting' => {
          'ocrLanguages' => self.language.to_s.upcase,
          'outputDocumentFormat' => self.format.to_s.upcase,
          'convertToBW' => self.convert_to_bw.to_s,
          'getOCRText' => true.to_s,
          'createOutputDocument' => outputfile?.to_s,
          'multiPageDoc' => self.multi_page_doc.to_s,
          'ocrWords' => false.to_s
        },
      }

      unless debug
        Savon.configure do |config|
        #config.log = true           # enable logging
         config.log = false          # disable logging
         config.log_level = :error   # changing the log level
         HTTPI.log = false           # to total silent the logging.
        end
      end
      client = Savon::Client.new('http://www.ocrwebservice.com/services/OCRWebService.asmx?WSDL')
      response = client.request(:ocr_web_service_recognize) do
        soap.body = request
      end

      return false if have_error? response.body

      if outputfile?
        File.open(outputfile, 'w+') {|f|
          f.puts Base64.decode64(response[:ocr_web_service_recognize_response][:ocrws_response][:file_data])
        }
      end

      set_text response[:ocr_web_service_recognize_response][:ocrws_response][:ocr_text][:array_of_string][:string]
    end

    def have_error? response
      return true && set_error("No response") unless response.has_key?(:ocr_web_service_recognize_response)
      return true && set_error("No response") unless response[:ocr_web_service_recognize_response].has_key?(:ocrws_response)
      return false unless response[:ocr_web_service_recognize_response][:ocrws_response].has_key?(:error_message)
      return false if response[:ocr_web_service_recognize_response][:ocrws_response][:error_message].nil?
      set_error response[:ocr_web_service_recognize_response][:ocrws_response][:error_message]
      true
    end
  end
end