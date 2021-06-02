class SendToCrmJob < ApplicationJob
  queue_as :default

  def perform(ticket)
    # ticket.save!
    ticket.send_ticket
  end
end
