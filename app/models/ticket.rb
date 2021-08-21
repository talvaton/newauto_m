class Ticket < ApplicationRecord
  validates :phone, presence: true


  def send_ticket
     # send_to_crm
    #send_to_roistat
    send_to_carso_crm
  end

  def send_to_carso_crm
    ticket = self
    begin
      uri = URI('http://178.62.202.129:2999/tickets/createsite')
      # uri = URI('http://www.localhost.ru:3000/tickets/createsite')

      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
    model = nil
    if ticket.other['model'].present?
      model = ticket.other['model']
    end

    req.body =
      {
        :secret => "3qXIe4Jp5NQmAzVOtge8",
        :ticket =>
          {
            :name => ticket.name,
            :phone => ticket.phone.gsub('-','').gsub('+7 ','8').gsub('(','').gsub(')','').gsub(' ',''),
            :model => model,
            :source => ticket.form_name,
            :entry_point => ticket.form_url,
            :utm_info => ticket.utm_info,
            :udata => ticket.udata
          }
      }.to_json

      res = http.request(req)
      logger.debug "ticket #{ticket.phone} send"
      ticket.send_to_crm = true
      ticket.save!
    rescue => e
      logger.fatal "ticket #{ticket.phone} NOT send"
      ticket.send_to_crm = false
      ticket.save!
    end
  end

  def region_by_phone(phone)
    require 'csv'
    code = phone[1,3]
    if code.present?
      filename = "#{code}.csv"
      if File.exist?(Rails.root + 'db/assets/phones/' + filename)
        cellphone = phone[4,phone.length]

        CSV.foreach(Rails.root + 'db/assets/phones/' + filename, :headers => true) do |row|
          if cellphone.to_i.between?(row['from'].to_i,row['to'].to_i)
            return row['region']
          end
        end
      else
        nil
      end
    end
  end

  def send_to_crm
    ticket = self
    require 'net/http'
    require 'json'

    model_id = nil
    if ticket.other.present?
      if ticket.other.present?
        model_id = ticket.other['model'].to_s
      end
    end


    if ticket.other['ttype'].present?
      ticket_type = true
    else
      ticket_type = false
    end

    db = MaxMindDB.new("#{Rails.root}/db/geo/GeoLite2-City.mmdb")

    geocity = db.lookup(ticket.udata['uip'])

    # GIFT
    if ticket.other['gift'].present?
      ticket.other['otherinfo'] = "Подарок: #{ticket.other['gift']}"
    end

    # TRADEIN
    if ticket.other['tradein_toggle'] == '1'
      if ticket.other['marka'].present?
        ticket.other['tradein_model'] = ticket.other['marka']
        ticket.other['tradein_toggle'] = "1"
      end
      if ticket.other['year'].present?
        ticket.other['tradein_year'] = ticket.other['year']
        ticket.other['tradein_toggle'] = "1"
      end
      if ticket.other['engine'].present?
        ticket.other['tradein_engine'] = ticket.other['engine']
        ticket.other['tradein_toggle'] = "1"
      end
      if ticket.other['probeg'].present?
        ticket.other['tradein_odo'] = ticket.other['probeg']
        ticket.other['tradein_toggle'] = "1"
      end
      if ticket.other['yourprice'].present?
        ticket.other['tradein_price'] = ticket.other['yourprice']
        ticket.other['tradein_toggle'] = "1"
      end
    end

    # credit_years,credit_percent
    if ticket.other['credit_years'].present?
      ticket.other['otherinfo'] = "#{ticket.other['otherinfo']} Срок кредита: #{ticket.other['credit_years']}"
    end

    if ticket.other['credit_percent'].present?
      ticket.other['otherinfo'] = "#{ticket.other['otherinfo']} Первоначальный взнос: #{ticket.other['credit_percent']}"
    end

    # CREDIT
    # if ticket.other['work'].present?
    #   ticket.other['work']
    #
    # end

    if ticket.other['first'].present?
      ticket.other['firstpayment'] = ticket.other['first']
    end
    # if ticket.other['gift'].present?
    #   ticket.other['otherinfo'] += "Подарок: #{ticket.other['gift']}"
    # end
    if ticket.other['complect'].present?
      if ticket.other['complect'] == 'Выберите комплектацию'
        ticket.other['complect'] = nil
      else
        complect_name = Equipment.find(ticket.other['complect'])
        ticket.other['otherinfo'] = "#{ticket.other['otherinfo']} Комплектация: #{complect_name.equipment_description.name} (#{complect_name.price})"
        if ticket.other['color'].present?
          ticket.other['otherinfo'] = "#{ticket.other['otherinfo']} #{ticket.other['color']}"
        end
      end
    end

    begin
      uri = URI('http://45.128.207.158:3000/tickets/createsite')
      http = Net::HTTP.new(uri.host, uri.port)
      req = Net::HTTP::Post.new(uri.path, {'Content-Type' =>'application/json'})
      req.body =
          {
              :secret => "cddc911b8159fa1f63b2c3f996af0529004e830189384389b6b34cb5db4746d5ffbbb7b3d72c45ea38dc3449a3dca16a3787972a1b9e4603fdfb9a4d9af7ca77",
              :region => geocity.subdivisions.most_specific.name(:ru),
              :ticket =>
                  {
                      :client => ticket.name,
                      :phone => ticket.phone.gsub('-','').gsub('+7 ','7').gsub('(','').gsub(')','').gsub(' ',''),
                      :form_url => ticket.form_url,
                      :form_name => ticket.form_name,
                      :other => ticket.other,
                      :city => geocity.city.name(:ru),
                      :utm_info => ticket.utm_info,
                      :udata => ticket.udata,
                      :car_id => model_id,
                      :ttype => ticket_type
                  }
          }.to_json

      res = http.request(req)
      puts "ticket #{ticket.phone} send"
      ticket.send_to_crm = true
      ticket.save!
    rescue => e
      logger.fatal "ticket #{ticket.phone} NOT send"
      ticket.send_to_crm = false
      ticket.save!
    end
  end

  def send_to_roistat
    ticket = self
    require 'net/http'
    require 'json'

    roistat = ticket.udata['roistat']
    r_key = Rails.application.credentials.roistat_key
    phone = ticket.phone.gsub('-','').gsub('+7 ','8').gsub('(','').gsub(')','').gsub(' ','')

    region_phone = region_by_phone(phone)
    if ticket.udata['uip'].present?
      db = MaxMindDB.new("#{Rails.root}/db/geo/GeoLite2-City.mmdb")
      geocity = db.lookup(ticket.udata['uip'])
      region_ip = "#{geocity.subdivisions.most_specific.name(:ru)} #{geocity.city.name(:ru)}"
    end

    region = "Дальний регион"

    unless region_phone.blank?
      regions = JSON.parse(File.read(Rails.root + 'db/assets/region_iden.json'))
      regions.each do |r|
        r['region'].each do |word|
          if region_phone.include? word
            region = r['priority']
          end
        end
      end
    end

    r_title = "#{ticket.form_name} - #{region}"
    # r_comment = "Комментарий"
    name = ticket.name

    # r_price = 0
    r_car = ""
    if ticket.other.present?
      if ticket.other['model'].present? && ticket.other['equipment'].present?
        model = NewCar.find(ticket.other['model'].to_i)
        eq = Equipment.find(ticket.other['equipment'].to_i)
        # r_price = model.count_price(eq.price)
        r_car = "#{model.brand.title} #{model.name}"
      end
      if ticket.other['used_car_id'].present?
        model = UsedCar.find(ticket.other['used_car_id'].to_i)
        r_car = "#{model.name} #{model.price}"
      end
    end

    if ticket.other['ttype'].present?
      r_type = "Кредит"
    else
      r_type = "Наличные"
    end

    trade_in = false
    trade_in_model = ""
    if ticket.other['tradein_toggle'] == '1'
      trade_in = true
      trade_in_model = ticket.other['tradeininfo']
      # trade_in_engine = ticket.other['tradein_engine']
      # trade_in_price = "700000р"
      # trade_in_year = 2007
      # trade_in_odo = 555555
    end

    begin
      uri = URI('https://cloud.roistat.com/api/proxy/1.0/leads/add')
      post_params =
          {
              :roistat => roistat,
              :key => r_key,
              :comment => roistat.to_s + ' @@@',
              :phone => phone,
              :title => r_title,
              :name => name,
              "fields[309019]" => r_type,
              "fields[309031]" => r_car,
              "fields[309081]" => trade_in,
              "fields[309143]" => trade_in_model,
              "fields[309013]" => region,
              "fields[337063]" => region_ip,
              "fields[337067]" => region_phone,
              "fields[442693]"=> ticket.form_name,
              "fields[442695]"=> ticket.utm_info['src']
          }
      # uri.query = URI.encode_www_form(post_params)

      res = Net::HTTP.post_form(uri,post_params)

      # Send event to roistat
      # res2 = Net::HTTP.get_response(URI.parse "https://cloud.roistat.com/api/site/1.0/143214/event/register?event=26262626&visit=#{roistat}")

      puts "ticket #{ticket.phone} send to ROISTAT"
      ticket.send_to_crm = true
      ticket.save!
    rescue => e
      logger.fatal "ticket #{ticket.phone} NOT send: #{e.message}"
      ticket.send_to_crm = false
      ticket.save!
    end
  end

end
