module OCR
  class Factory
    attr_reader :args

    class << self
      protected :new
    end

    def initialize(*args)
      self.init(*args) if self.respond_to?(:init)
    end

    def self.create(type = self.class, *args)
      raise ArgumentError, "Cannot create instance of #{type} from #{self.name}" if type == self
      raise ArgumentError, "Type cannot be nil" if type.nil?

      if !type.ancestors.include?(self)
        raise ArgumentError, "#{type.name} is not a descendant of #{self.name}"
      end
      type.new(*args)
    end
  end
end