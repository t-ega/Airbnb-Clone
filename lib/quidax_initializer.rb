module QuidaxInitializer
  def self.included(klass)
    klass.extend Initializer
    klass.initialize_quidax_object
  end
end

module Initializer
  attr_reader :quidax_object

  def initialize_quidax_object
    secret_key = ENV["QUIDAX_SECRET_KEY"]
    @quidax_object = Quidax.new(secret_key)
  end
end
