require 'savon'

module OCR
  class Free_ocr < OCR::Ocr

    attr_accessor :convert_to_bw

    private
    def init
      super()
    end

    def ocr_recognize
      raise Exception, 'You should set image file' unless @file
      request = {
        'image' => File.open(@file, 'rb') { |f| [f.read].pack('m*') }
      }
      request[:username] = @username if @username

      client = Savon::Client.new('http://www.free-ocr.co.uk/ocr.asmx?WSDL')

      response = client.request(:analyze) do
        soap.body = request
      end

      return false if have_error? response.body
      set_text response.body[:analyze_response][:analyze_result]
    end

    def have_error? response
      return true && set_error("No response") unless response.has_key?(:analyze_response)
      return true && set_error("No response") unless response[:analyze_response].has_key?(:analyze_result)
    end
  end
end