module OCR
  class Ocr < OCR::Factory
    class << self
      private :create
    end

    attr_reader :text, :error
    attr_accessor :username, :password, :extra_login_data
    attr_accessor :proxy_addr, :proxy_port, :proxy_user, :proxy_pass
    attr_accessor :file, :outputfile, :language, :format
    attr_accessor :debug, :rescue_exceptions

    def initialize(*args)
      init
    end

    def init
      clear_error
      clear_text
      login false, false
      proxy false
      file= false
      lang= false
      format= false
      outputfile= false
      debug= false
      rescue_exceptions= true
    end

    def rescue_exceptions?
      @rescue_exceptions != false
    end

    def login username, password, extra_login_data = false
      @username = username
      @password = password
      @extra_login_data = extra_login_data
    end

    def proxy p_addr, p_port = nil, p_user = nil, p_pass = nil
      @proxy_addr = p_addr
      @proxy_port = p_port
      @proxy_user = p_user
      @proxy_pass = p_pass
    end

    def error?
      @error != false
    end

    def outputfile?
      outputfile != false
    end

    def recognize
      clear_error
      clear_text
      return false && set_error("No file") if @file.nil?
      return false && set_error("File not exists '#{@file}'") unless File.exist?(@file)
      begin
        ocr_recognize
      rescue Exception => msg
        set_error msg
        raise unless rescue_exceptions?
      end
    end

    private
      def clear_error
        @error = false
      end

      def set_error msg
        @error = msg
      end

      def clear_text
        @text = nil
      end

      def set_text msg
        @text = msg
      end

      def ocr_recognize
        raise NotImplementedError, 'You should implement this method'
      end
  end
end