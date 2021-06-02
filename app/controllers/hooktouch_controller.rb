class HooktouchController < ApplicationController
  def receive
    roi = nil

    if params['attrs'].present?
      if params['attrs']['roistat_visit'].present?
        roi_from_attr = JSON.parse params['attrs']
        roi =  roi_from_attr['roistat_visit']
      end
    end

    seogoogle = ["78003332867","74952926710"]
    seoyandex = ["78003332518","74952926709"]
    seodirect = ["78003334521","74952926712"]

    unless roi.present?
      case params['phonenumber']
      when *seogoogle
        roi = "seo_google"
      when *seoyandex
        roi = "seo_yandex"
      when *seodirect
        roi = "organic"
      else
        roi = nil
      end
    end

    t_url='/'

    if params["url"].present?
      t_url = params["url"].split('?')[0]
    end

    u_data = {}
    if params['userAgent'].present?
      u_data = {uag:params['userAgent'],uip:params['ip'], roistat:roi}
    else
      u_data = {roistat:roi}
    end
    
    t_params = {
        name:"Неизвестный контакт",
        phone:params["callerphone"],
        form_name:"Звонок с сайта",
        form_url:t_url,
        utm_info:{"cid":params["gcid"],cmp:params['utm_campaign'],src:params["utm_source"],trm:params["utm_term"] },
        udata:u_data,
        other:{}
    }

    ticket = Ticket.new(t_params)
    ticket.save!

    WebhookToAmocrm.perform_later ticket

    render json: {"status":"OK"}, status: 200
  end

  def hookamo
    roistat = ''

    # test_params = {"leads"=>{"add"=>{"0"=>{"id"=>"13977895", "name"=>"Обратный звонок - Дальний регион", "status_id"=>"31180999", "old_status_id"=>nil, "price"=>"0", "responsible_user_id"=>"3947458", "last_modified"=>"1584363867", "modified_user_id"=>"3947458", "created_user_id"=>"3947458", "date_create"=>"1584363866", "pipeline_id"=>"2167081", "account_id"=>"28701490", "custom_fields"=>{"0"=>{"id"=>"309019", "name"=>"Тип заявки", "values"=>{"0"=>{"value"=>"Наличные", "enum"=>"440109"}}}, "1"=>{"id"=>"309081", "name"=>"Трейд ин", "values"=>{"0"=>{"value"=>"1"}}}, "2"=>{"id"=>"329987", "name"=>"roistat", "values"=>{"0"=>{"value"=>"2477734"}}}, "3"=>{"id"=>"442693", "name"=>"Источник", "values"=>{"0"=>{"value"=>"Обратный звонок"}}}, "4"=>{"id"=>"442695", "name"=>"UTM_source", "values"=>{"0"=>{"value"=>"google"}}}}, "created_at"=>"1584363866", "updated_at"=>"1584363867"}}}}

    if params['leads'].present?
      if params['leads']['add'].present?
        roi_from_attr = params['leads']['add']['0']['custom_fields']
        roi_from_attr.each do |k,v|
          if v['id'] == '329987'
            roistat = v['values']['0']['value']
          end
        end
      end
    end
    logger.fatal "hookamo123 #{params}"
    
    res = Net::HTTP.get_response(URI.parse "https://cloud.roistat.com/api/site/1.0/143214/event/register?event=26262626&visit=#{roistat}")
  end
end
