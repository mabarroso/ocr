require 'net/http'
require 'rexml/document'

module OCR
  class Weocr < OCR::Ocr

    attr_accessor :outputencoding, :servers, :server_cgi

    def ocr_servers
      @servers = []
      # Get OCR servers
      url = 'http://weocr.ocrgrid.org/cgi-bin/weocr/search.cgi?lang=&fmt=xml'
      xml_data = Net::HTTP.get(URI.parse(url))
      doc = REXML::Document.new(xml_data)
      doc.elements.each('weocrlist/server/url') do |ele|
        @servers << ele.text
      end

      return unless @servers.count > 0

      xml_data = Net::HTTP.get(URI.parse("#{@servers[0]}srvspec.xml"))
      doc = REXML::Document.new(xml_data)
      doc.elements.each('ocrserver/svinfo/cgi') do |ele|
        @server_cgi = ele.text
      end
    end

    private
    def init
      super()
      self.outputencoding= 'utf-8'
      self.server_cgi= false
      self.ocr_servers
    end

    def ocr_recognize
      raise Exception, 'No available OCR server' unless @server_cgi
     res = `curl -F userfile=#{@file} \
     -F outputencoding="#{outputencoding}" \
     -F outputformat="#{format.to_s}" \
     #{@server_cgi}`

puts res
return


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