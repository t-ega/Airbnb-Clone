class CreateSubAccountJob < ApplicationJob
  def perform(host_id)
    CreateSubAccountService.call(host_id)
  end
end
