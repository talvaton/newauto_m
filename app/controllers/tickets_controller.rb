class TicketsController < ApplicationController

  # invisible_captcha only: [:create], honeypot: :ticket_text

  def create
    info = {}
    if cookies[:sbjs_current].present?
      utm_arr = cookies[:sbjs_current].split('|||')
      utm_arr.each do |utm|
        res = utm.split('=')
        info[res[0]] = res[1]
      end
      if cookies["_ga"].present?
        info[:cid] = cookies["_ga"].split(".").last(2).join(".")
      end
      # info = {:typ => utm[0],:src => utm[1], :mdm => utm[2], :cmp => utm[3], :cnt => utm[4], :trm => utm[5] }
    end
      #
      # client_id = cookies["_ga"].split(".").last(2).join(".")
      # puts client_id
      # puts 'test'

    form_url_string = request.env['HTTP_REFERER'].split('?')

    additional_params = {
        form_url: form_url_string[0],
        udata: {uag: request.env['HTTP_USER_AGENT'],uip: request.remote_ip,roistat: cookies[:roistat_visit]},
        utm_info: info
    }

    @ticket = Ticket.new(ticket_params.to_h.merge!(additional_params))

    unless @ticket.other.present?
      @ticket.other = {}
    end

    @ticket.save!

    @tickets_per_day_count = Ticket.where(phone: @ticket.phone).where('DATE(created_at) = CURDATE()').count

    SendToCrmJob.perform_later @ticket

    if params['hide_popup'].present?
      render 'carso/tickets/create_no_popup'
    end
  end

  def orders
    head :unauthorized unless params[:secret] === '2eIfi4XFXdXFa07Ml9jV'
    from_date = DateTime.parse params[:from]
    @tickets = Ticket.where('created_at + INTERVAL 3 HOUR BETWEEN ?  AND CURRENT_TIMESTAMP()  + INTERVAL 3 HOUR', from_date)
  end

  private

  def ticket_params
    params.require(:ticket).permit(
        :name,:phone,:form_name,
        other:[:gift,:marka,:tradeininfo,:model,:equipment,
               :credit_percent,:credit_years,
               :complect,:spec,:used_car_id,
               :year, :engine, :probeg, :yourprice,
               :work,:city,:first,:color,
               :ttype,:tradein_toggle]
    )
  end
end