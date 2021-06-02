class WebhookToAmocrm < ApplicationJob
  queue_as :default

  def perform(ticket)
    ticket.send_to_roistat
  end
end
