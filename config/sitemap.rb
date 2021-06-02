Region.all.each do |domain|

  if domain.name === 'moskva'
    SitemapGenerator::Sitemap.default_host = "https://carso.ru/"
  else
    SitemapGenerator::Sitemap.default_host = "https://#{domain.name}.carso.ru/"
  end

  SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/#{domain.name}"
  # SitemapGenerator::Sitemap.sitemaps_path = "#{domain.name}"
  SitemapGenerator::Sitemap.compress = false
  SitemapGenerator::Sitemap.create do

    #nums = [300000,350000,400000,450000,500000,550000,600000,650000,700000,800000,900000,1000000,1100000,1200000,1250000,1300000,1400000,1500000,1700000,2000000,2500000,3000000]
    #nums.each do |num|
    #  add do_path(num)
    #  add do_type_path('vnedorozhniki', num)
    #end

    add '/tradein'
    #add '/conf-policy'
    #add '/korporativnym-klientam'
    #add '/utilizaciya'
    #add '/stock'
    add '/credit'
    add '/banks/programma-pervyy-avtomobil'
    add '/banks/programma-semeynyy-avtomobil'
    #add '/topsales'
    #add '/konfigurator'

    #Brand.where(hide: false).find_each do |brand|
    #  add brand_credit_path(brand.url)
    #  if domain.name === 'www'
    #    add konfigurator_brand_path(brand.url)
    #  end

    #end

    Brand.where(hide: false).find_each do |brand|
      NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
        add new_car_credit_path(brand.url, car.url)
      end
    end

    Brand.where(hide: false).find_each do |brand|
      NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
        add new_car_tradein_path(brand.url, car.url)
      end
    end

    Brand.where(hide: false).find_each do |brand|
      NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
        add new_car_taxi_path("#{brand.url}-#{ car.url}")
      end
    end

    Articles.find_each do |brand|
        add articles_path(brand.url)
    end
    Overviews.find_each do |brand|
      add overviews_path(brand.url)
    end

    add '/contacts'
    add '/newauto'
    add '/articles'
    add '/blog'

    countries = JSON.parse(File.read(Rails.root + 'db/assets/countries.json'))
    countries.each do |country|
      add new_car_country_path(country['url'])
    end

    types = JSON.parse(File.read(Rails.root + 'db/assets/types.json'))
    types.each do |type|
      add new_car_type_path(type['url'])
    end

    Brand.where(hide: false).find_each do |brand|
      add brand_path(brand.url)
      brand_car_types = NewCar.where(brand_id: brand.id,hide: 0, archive: 0).distinct.pluck(:car_type)
      brand_car_types.each do |t|
        if t.present?
          add brand_type_path(brand.url,I18n.t("car_types.#{t}"))
        end
      end
      NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
        add new_car_path(brand.url, car.url)

        #if domain.name === 'www'
        #  add new_car_tth_path(brand.url, car.url)
        #  add konfigurator_model_path(brand.url, car.url)
        #end

      end
    end

    Brand.where(hide: false).find_each do |brand|
      NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
        EquipmentDescription.where(new_car_id: car.id).find_each do |equip|
          eq = equip.name.to_s.parameterize
          if eq.present?
            add new_car_equipment_path(brand.url, car.url, eq)
          end
        end
      end
    end

    Brand.where(hide: false).find_each do |brand|
      NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
        EquipmentDescription.where(new_car_id: car.id).find_each do |equip|
          equips = equip.equipments.where(hide: 0)
          equips.find_each do |equip_id|
            eq = equip.name.to_s.parameterize
            eq_id = equip_id.id.to_s.parameterize
            if eq.present?
              add new_car_equipment_id_path(brand.url, car.url, eq, eq_id)
            end
          end
        end
      end
    end

    #Brand.where(hide: false).find_each do |brand|
    #  NewCar.where(brand_id: brand.id).where(hide: 0).find_each do |car|
    #    if car.color_group.present?
    #      colors = JSON.parse car['color_group']
    #      colors.each do |color|
    #        add new_car_color_path(brand.url, car.url, color)
    #      end
    #    end
    #  end
    #end

    #add '/news'

    #if domain.name === 'www'
    #  add '/blog'
    #  Brand.where(hide: false).find_each do |brand|
    #    add blog_brand_path(brand.url)
    #  end

    #  Brand.where(hide: false).find_each do |brand|
    #    NewCar.where(brand_id: brand.id).find_each do |model|
    #      add blog_car_path(brand.url, model.url)
    #    end
    #  end
    #end

   # add '/sprobegom'

    #Brand.where(hide: false).find_each do |brand|
    #  add used_brand_path(brand.url)
    #end

    #Brand.where(hide: false).find_each do |brand|
    #  UsedCar.where(brand_id: brand.id).select('DISTINCT url').used_cars.each do |model|
    #    add used_brand_model_path(brand.url, model.url)
    #  end
    #end

    #Brand.where(hide: false).find_each do |brand|
    #  UsedCar.where(brand_id:brand).used_cars.collect{|u| u.year }.uniq.sort.each do |y|
    #    add used_brand_year_path(brand.url, y)
    #  end
    #end

    #Brand.where(hide: false).find_each do |brand|
    #  UsedCar.where(brand_id: brand.id).select('DISTINCT url').used_cars.each do |model|
    #    UsedCar.where(brand_id:brand, url: model).used_cars.collect{|u| u.year }.uniq.sort.each do |y|
    #      add used_brand_model_year_path(brand.url, model.url, y)
    #    end
    #  end
    #end

    #years = [2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018]
    #years.each do |year|
    #  add used_year_path(year)
    #end

    #prices = [150000,200000,250000,300000,350000,400000,450000,500000,550000,600000,700000,750000,800000,850000,900000,950000,1000000,1500000,2000000]
    #prices.each do |price|
    #  add used_price_path(price)
    #end

    #countries.each do |country|
    #  add used_country_path(country['url'])
    #end

    #types.each do |type|
    #  add used_type_path(type['url'])
    #end

    # add '/sprobegom/mkpp'
    # add '/sprobegom/akpp'
    # add '/sprobegom/variator'
    #transmissions = ['mkpp','akpp','variator']
    #transmissions.each do |transmission|
    #  add used_transmission_path(transmission)
    #end

    #add '/deals'

    #Brand.where(hide: false).find_each do |brand|
    #  add special_brand_path(brand.url)
    #end

    #Brand.where(hide: false).find_each do |brand|
    #  UsedCar.where(brand_id: brand.id).select('DISTINCT url').special_cars.each do |model|
    #    add special_model_path(brand.url, model.url)
    #  end
    #end

    add '/reviews'

    #Brand.where(hide: false).find_each do |brand|
    #  add review_brand_path(brand.url)
    #end

    #Brand.where(hide: false).find_each do |brand|
    #  NewCar.where(brand_id: brand.id).find_each do |model|
    #    add review_model_path(brand.url, model.url)
    #  end
    #end

  end

  SitemapGenerator::Sitemap.search_engines
  # rails sitemap:refresh:no_ping

end