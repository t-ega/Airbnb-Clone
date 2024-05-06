module Types
  class ResponseStatusType < Types::BaseEnum
    value "SUCCESS", "Indicates that the response was successful", value: :success
    value "ERROR", "Indicates that the response was not successful", value: :error
  end
end