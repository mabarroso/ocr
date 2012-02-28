require 'net/http'
require 'rexml/document'
require 'nokogiri'

module OCR
  class Weocr < OCR::Ocr

    attr_accessor :outputencoding, :servers, :servers_info, :server_cgi

    def ocr_servers
      @servers = []
      @servers_info = {}
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
     res = `curl -F userfile=@#{@file} \
     -F outputencoding="#{outputencoding}" \
     -F outputformat="#{format.to_s}" \
     #{@server_cgi} 2>/dev/null`

      doc = Nokogiri::HTML.parse(res)
      err = doc.search('h2').first
      return false if have_error? err.content if err
      set_text doc.search('pre').first.content
    end

    def have_error? response
      return true && set_error(response) if response
    end
  end
end