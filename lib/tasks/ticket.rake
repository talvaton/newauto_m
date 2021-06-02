namespace :tickets do

  desc %Q{ Try to send tickets }
  task :send => :environment do
    # include Rails.application.routes.url_helpers

    not_send = Ticket.where(send_to_crm: nil)

    not_send.each do |t|
      t.send_ticket
    end

    # sh %{puma -e saloncentr -d -b unix:///tmp/salon_web.sock --pidfile /tmp/puma.pid}
  end
end