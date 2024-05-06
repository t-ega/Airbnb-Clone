# frozen_string_literal: true

class GraphQL::ExecutionError < GraphQL::Error
  attr_accessor :error, :record

  def initialize(error, extensions: nil)
    @error = error
    @extensions = extensions
  end

  def to_h
    hash = {
      "message": error
    }

    if extensions
      hash["extensions"] = extensions.each_with_object({}) { |(key, value), ext|
        ext[key.to_s] = value
      }
      value = extensions.each_with_object({}) { |(key, value), ext|
        ext[key.to_s] = value
      }
      puts value
    end

    hash
  end
end