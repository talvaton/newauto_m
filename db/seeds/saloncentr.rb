require 'colorize'

start = Time.now

puts 'region start'
regions = JSON.parse(File.read(Rails.root + 'db/assets/regions.json'))
regions.each do |region|
  reg = Region.new
  reg.name = region['name']
  reg.sklon1 = region['sklon1']
  reg.sklon2 = region['sklon2']
  reg.sklon3 = region['sklon3']
  reg.save!
end
puts 'region end'

puts 'bank start'

banks = JSON.parse(File.read(Rails.root + 'db/assets/banks.json'))
banks.each do |bank|
  b = Bank.new
  b.name = bank['name']
  b.url = bank['url']
  b.description = bank['description']
  b.save!

  # Dirty hack for images, not to duplicate them or recreate...
  path_to_file = Rails.root.join("public/uploads/bank/#{b.id}/image/#{bank['image']}")
  if File.exist?(path_to_file)
    b['image'] = bank['image']
  else
    puts 'not exist'.red
    b.image = Rails.root.join("app/assets/images/centr/banks/" + bank['image']).open
  end

  b.save!
end
puts 'bank end'

puts 'brand start'
brands = JSON.parse(File.read(Rails.root + 'db/assets/brands.json'))
brands.each do |brand|
  b = Brand.new
  b.title = brand['title']
  b.menutitle = brand['menutitle']
  b.url = brand['url']

  desc = {}
  if brand['brand_desc'].present?
    desc[:brand_desc] = brand['brand_desc']
  end

  if brand['brand_seotext'].present?

    brand_seo = JSON.parse(brand['brand_seotext'])

    b_seo = []
    brand_seo.each do |seo|
      b_seo.push(seo['Seotextblock'].gsub('/Сhery/','/Chery/').gsub('/UAZ/','/Uaz/').gsub('/KIA/','/Kia/').gsub('/Сitroen/','/Citroen/').gsub('assets/','/static/'))
    end

    desc[:brand_seotext] = b_seo.join('')

  end
  b.description = desc

  if brand['published'] == 1
    b.hide = false
  else
    b.hide = true
  end

  if brand['official'] == 1
    b.official = true
  else
    b.official = false
  end

  if brand['hide'] == 1
    b.menu_show = 0
  else
    b.menu_show = 1
  end

  #logos
  b.save!


  # Work with Brand images

  #cert
  if brand['cert']
    path_to_file = Rails.root.join("public/uploads/brand/cert/#{brand['cert'].gsub('assets/images/sert/','')}")
    if File.exist?(path_to_file)
      b['cert'] = brand['cert'].gsub('assets/images/sert/','')
    else
      puts 'cert not exist'.red
      puts "#{brand['cert'].gsub('assets/images/sert/','')}"
      b.cert = Rails.root.join("public/tmp/brand_cert/" + brand['cert'].gsub('assets/images/sert/','')).open
    end
  end

  #logo
  path_to_file = Rails.root.join("public/uploads/brand/logo/#{File.basename( "#{brand['logo'].gsub('assets/images/logo/','')}", ".*" ).parameterize}.png")
  if File.exist?(path_to_file)
    b['logo'] = "#{File.basename( "#{brand['logo'].gsub('assets/images/logo/','')}", ".*" ).parameterize}.png"
    b['logoblack'] = "#{File.basename( "#{brand['logoblack'].gsub('assets/images/logo/','')}", ".*" ).parameterize}.png"
  else
    puts 'not exist'.red
    puts "#{brand['logo'].gsub('assets/images/logo/','').parameterize}"
    b.logo = Rails.root.join("public/tmp/brand_logo/" + brand['logo'].gsub('assets/images/logo/','')).open
    b.logoblack = Rails.root.join("public/tmp/brand_logo/" + brand['logoblack'].gsub('assets/images/logo/','')).open
  end

  b.save!
end
puts 'brand end'

puts 'news start'
newslist = JSON.parse(File.read(Rails.root + 'db/assets/news.json'))
newslist.each do |news_item|
  ni = Story.new
  ni.name = news_item['pagetitle']
  content = news_item['content']
  ni.newstext = content.gsub('/assets/images/', '/tmp/')
  if news_item['brand'].present?
    brand = Brand.where(title: news_item['brand'].gsub('ВАЗ','Lada').gsub('Uaz','Уаз').gsub('Vaz','Lada')).first_or_create!
    ni.brand_id = brand.id
  end
  ni.created_at = Time.at(news_item['createdon'])
  ni.url = news_item['alias']

  ni.save!

  # NEWS images

  path_to_file = Rails.root.join("public/uploads/story/#{ni.id}/newsImage/#{File.basename( "#{news_item['newsimage']}", ".*" ).parameterize(separator: "_")}#{File.extname( "#{news_item['newsimage']}")}")
  if File.exist?(path_to_file)
    ni['newsImage'] = "#{File.basename( "#{news_item['newsimage']}", ".*" ).parameterize(separator: "_")}#{File.extname( "#{news_item['newsimage']}")}"
  else
    puts 'not exist'.red
    puts ni.id
    puts "#{File.basename( "#{news_item['newsimage']}", ".*" ).parameterize(separator: "_")}#{File.extname( "#{news_item['newsimage']}")}"
    ni.newsImage = Rails.root.join("public/tmp/news/" + news_item['newsimage']).open
  end
  ni.save!
end
puts 'news end'

puts 'reviews start'
reviews = JSON.parse(File.read(Rails.root + 'db/assets/reviews.json'))
reviews.each do |rev|
  review = Review.new
  review.name = rev['name']
  review.rev_text = rev['reviewtext']
  # review[:image] = '1.JPG'
  # review.image = Rails.root.join("public/tmp/reviews/" + rev['image']).open
  review.created_at = rev['date']

  review.save!

  path_to_file = Rails.root.join("public/uploads/review/#{review.id}/image/#{File.basename( "#{rev['image']}", ".*" ).parameterize}#{File.extname( "#{rev['image']}")}")
  if File.exist?(path_to_file)
    review['image'] = "#{File.basename( "#{rev['image']}", ".*" ).parameterize}#{File.extname( "#{rev['image']}")}"
  else
    puts "not exist #{review.id}".red
    puts "#{File.basename( "#{rev['image']}", ".*" ).parameterize}#{File.extname( "#{rev['image']}")}"

    review.image = Rails.root.join("public/tmp/reviews/" + rev['image']).open
  end

  review.save!
end
puts 'reviews end'

puts 'usedcars start'
used_cars = JSON.parse(File.read(Rails.root + 'db/assets/used_cars.json'))
used_cars.each do |car|
  c = UsedCar.new
  # c.id = car['id']
  c.name = car['model']
  brand = Brand.where(title: car['brand']).first_or_create!
  c.brand = brand
  c.price = car['price']
  c.odometer = car['odometer']
  c.year = car['year']
  c.vin = car['vin']
  if car['avito'] == 1
    c.avito = true
  else
    c.avito = false
  end
  if car['published'] == 1
    c.hide = false
  else
    c.hide = true
  end
  c.car_type = car['type']

  if car['parameters']
    params = JSON.parse car['parameters']
    params.each do |param|
      c.owners = param['owners']
      c.condition = param['status']
      c.color = param['color']
      c.transmission = param['transmission']
      c.volume = param['engine_volume']
      c.power = param['power']
      c.drive = param['drive']
      compl_h = {}
      compl_h[:steer] = param['steer']
      compl_h[:enginetype] =  param['engine_type']
      compl_h[:interior] = param['interior']
      compl_h[:interior_color] = param['interior_color']
      compl_h[:driverseatreg] = param['driverseatreg']
      compl_h[:passengerseatreg] = param['passengerseatreg']
      compl_h[:steerreg] = param['steerreg']
      compl_h[:climatcontrol] = param['climatcontrol']
      compl_h[:airbag] = param['airbag']
      compl_h[:multimedia] = param['multimedia']
      compl_h[:power_window] = param['power_window']
      compl_h[:power_steering] = param['power_steering']
      compl_h[:other] = param['complect']
      c.complectation = compl_h
    end
  end

  c.used = true
  c.save!

  if car['images']
    images = JSON.parse car['images']

    result = []
    result_files = []
    flag = true

    images.each do |img|
      file_name = "#{File.basename( "#{img['imagepath']}", ".*" ).parameterize.gsub('-','_').gsub('__','_')}#{File.extname( "#{img['imagepath']}")}".gsub('_.','.')
      path_to_file = Rails.root.join("public/uploads/used_cars/#{c.id}/images/#{file_name}")
      unless File.exist?(path_to_file)
        flag = false
        puts file_name
      end

      file = Rails.root.join("public/tmp/photo_used/" + img['imagepath']).open
      result_files.push(file)
      result.push(file_name)
    end
    if flag
      c['images'] = result
    else
      puts "not exist #{c.id}".red
      c.images = result_files
    end

  end
  c.save!
end
puts 'usedcars end'

puts 'specialcars start'
special_cars = JSON.parse(File.read(Rails.root + 'db/assets/special_cars.json'))
special_cars.each do |car|
  c = UsedCar.new
  # c.id = car['id']
  c.name = car['model']
  c.menutitle = car['menutitle']
  brand = Brand.where(title: car['brand']).first_or_create! do |brand|
    brand.hide = 1
  end

  c.brand = brand
  c.price = car['price']
  c.year = car['year']
  c.vin = car['vin']
  if car['avito'] == 1
    c.avito = true
  else
    c.avito = false
  end
  c.color = car['color']
  c.car_type = car['type']

  if car['parameters']
    params = JSON.parse car['parameters']
    params.each do |param|
      c.transmission = param['transmission']
      c.volume = param['engine_volume']
      c.power = param['power']
      c.drive = param['drive']

      compl_h = {}
      compl_h[:other] = param['complect']
      c.complectation = compl_h
    end
  end

  if car['published'] == 1
    c.hide = false
  else
    c.hide = true
  end
  c.used = false
  c.save!


  if car['images']
    images = JSON.parse car['images']

    result = []
    result_files = []
    flag = true

    images.each do |img|


    file_name = "#{File.basename( "#{img['imagepath']}", ".*" ).parameterize.gsub('-','_').gsub('__','_')}#{File.extname( "#{img['imagepath']}")}".gsub('_.','.')
    # file_name = "#{File.basename( "#{img['imagepath']}", ".*" ).parameterize.gsub('-','_')}#{File.extname( "#{img['imagepath']}")}"
    path_to_file = Rails.root.join("public/uploads/used_cars/#{c.id}/images/#{file_name}")
      unless File.exist?(path_to_file)
        flag = false
        puts file_name
      end

      file = Rails.root.join("public/tmp/photo_used/" + img['imagepath']).open
      result_files.push(file)
      result.push(file_name)
    end
    if flag
      # c.images = result_files
      c['images'] = result
    else
      puts "not exist #{c.id}".red
      c.images = result_files
    end

  end
  c.save!
end
puts 'specialcars end'

puts 'new cars start'
cars = JSON.parse(File.read(Rails.root + 'db/assets/cars.json'))
cars.each do |car|
  c = NewCar.new
  c.id = car['id']
  b = Brand.find_by(url: car['brand_name'])
  c.brand = b
  c.name = car['name']
  c.russian_name = car['russian_name']
  c.menutitle = car['menutitle']
  # c.description = car['description']
  c.url = car['alias'].gsub('.','')
  if car['alias'].end_with? 'old'
    c.old = true
  end

  # puts car['published']
  if car['published'] == 1
    c.hide = false
  else
    c.hide = true
  end
  c.discount = car['discount']
  c.discount_credit = car['discount_credit']
  c.discount_tradein = car['discount_tradein']
  if car['half_discount']
    c.half_discount = true
  end
  c.car_type = car['car_type']

  if car['car_link']
    cl = JSON.parse car['car_link']
    result = []
    cl.each do |s|
      result.push(s['car'])
    end
    c.car_link = result
  end

  c.country = car['country']
  c.warranty = car['warranty']

  if car['special_options']
    so = car['special_options']
    c.special_options = so.split('||')
  end

  if car['video_link'].present?
    c.video_link = car['video_link']
                       .gsub('https://www.youtube.com/embed/','')
                       .slice(0..10)
  end

  if car['seo_text']
    st = JSON.parse car['seo_text']
    result = {}
    lower_t = []

    doc = Nokogiri::HTML(st[0]['Seotextblock'])
    doc.css('div').each_with_index do |d,index|
      if index == 0
        result[:text_upper] = d.children.to_html
      else
        lower_t.push(d.to_html)
      end
    end
    if lower_t.present?
      result_lower_t = lower_t.join
                           .gsub('assets/images/img_text/', '/static/images/img_text/')
                           .gsub('"catalog/', '"/catalog/')
                           .gsub('/%D0%A1hery/','/Chery/')
                           .gsub('/UAZ/','/Uaz/')
                           .gsub('/KIA/','/Kia/')
                           .gsub('/%D0%A1itroen/','/Citroen/')
      result[:text_lower] = result_lower_t
    end

    c.description = result
  end

  c.save!

  if car['colors']
    colors = JSON.parse car['colors']
    result = []
    result_files = []
    options = []
    flag = true
    colors.each do |col|

      file_name = "#{File.basename( "#{col['photo']}", ".*" ).parameterize.gsub('-','_').gsub('__','_')}#{File.extname( "#{col['photo']}")}".gsub('_.','.')
      path_to_file = Rails.root.join("public/uploads/new_car/#{c.id}/colors/#{file_name}")

      unless File.exist?(path_to_file)
        flag = false
        puts file_name
      end

      file = Rails.root.join("public/tmp/newcars/" + car['id'].to_s + "/colors/" + col['photo']).open
      result_files.push(file)
      result.push(file_name)

      opt = {colorname: col['colorname'],color: col['color'],color2: col['color_2']}
      options.push(opt)
    end

    if flag
      # c.colors = result_files
      c['colors'] = result
    else
      c.colors = result_files

      puts "not exist #{c.id}".red
    end
    c.color_options = options
  end

  if car['NewImageList']
    images = JSON.parse car['NewImageList']
    result = []
    result_files = []
    flag = true
    images.each do |img|

      path_to_file = Rails.root.join("public/uploads/new_car/#{c.id}/images/#{img['imagepath']}")

      unless File.exist?(path_to_file)
        flag = false
        puts img['imagepath']
      end
      file = Rails.root.join("public/tmp/newcars/" + c.id.to_s + "/photo/" + img['imagepath']).open
      result_files.push(file)

      result.push(img['imagepath'])
    end
    if flag
      c['images'] = result
      # c.images = result_files

    else
      c.images = result_files
      puts "not exist #{c.id}".red
    end
  end

  if car['View360']
    view = JSON.parse car['View360']
    result = []
    result_files = []
    flag = true
    view.each do |img|
      file_name = "#{File.basename( "#{img['image']}", ".*" ).parameterize}#{File.extname( "#{img['image']}")}"

      path_to_file = Rails.root.join("public/uploads/new_car/#{c.id}/images360/#{file_name}")
      unless File.exist?(path_to_file)
        flag = false
        puts file_name
      end

      file = Rails.root.join("public/tmp/newcars/" + car['id'].to_s + "/360/" + img['image']).open
      result_files.push(file)
      result.push(file_name)

    end
    if flag
      c['images360'] = result
    else
      c.images360 = result_files
      puts 'not exist'.red
    end
  end

  c.save!
end
puts 'new cars end'

puts 'spec start'
specifications = JSON.parse(File.read(Rails.root + 'db/assets/specifications.json'))
specifications.each do |spec|
  if spec['specifications'].present?
    tech = JSON.parse(spec['specifications'])
    tech.each do |t|
      s = Specification.new
      s.new_car = NewCar.find(spec['id'])
      s.name = t['name']
      s.enginetype = t['enginetype']
      s.volume = t['volume']
      s.power = t['power']
      s.acceleration = t['acceleration']
      s.topspeed = t['topspeed']

      s.fuelcity = t['fuelcity']
      s.fuelhigh = t['fuelhigh']
      s.fuelmix = t['fuelmix']
      s.tank = t['tank']

      s.length = t['length']
      s.width = t['width']
      s.height = t['height']
      s.wheelbase = t['wheelbase']
      s.clearance = t['clearance']
      s.mass = t['mass']
      s.trunk = t['trunk']
      s.transmission = t['transmission']
      s.shorttransmission = t['shorttransmission']
      s.drive = t['drive']
      s.frontsusp = t['frontsusp']
      s.rearsusp = t['rearsusp']
      s.frontbrakes = t['frontbrakes']
      s.rearbrakes = t['rearbrakes']

      s.save!
    end
  end
  if spec['equipment_description'].present?
    desc = JSON.parse(spec['equipment_description'])
    desc.each do |d|
      # puts d['Published']
      if d['Published'] != '1'
        ed = EquipmentDescription.new
        ed.name = d['compldescname']
        ed.description = d['description']
        ed.new_car = NewCar.find(spec['id'])
        ed.save!
      end
    end
  end
  if spec['equipment'].present?
    equip = JSON.parse(spec['equipment'])
    equip.each do |e|
      sp_id = Specification.where(new_car_id: spec['id'])
      ed = EquipmentDescription.where(name: e['complname']).where(new_car_id: spec['id'])
      if sp_id.present? && ed.present?
        eq = Equipment.new
        # sp_id = Specification.where(new_car_id: spec['id'])
        eq.specification = sp_id[e['tech'].to_i - 1]
        # puts ed.id
        # debugger
        eq.equipment_description = ed.first
        eq.price = e['price']
        eq.suffix = e['suffix']

        eq.save!
      end
    end
  end
end
puts 'spec end'

puts 'used_brand start'
ubrands = JSON.parse(File.read(Rails.root + 'db/assets/used_brands.json'))
ubrands.each do |brand|
  b = Brand.find_or_initialize_by(title: brand["title"])

  # puts brand['used_seotext']
  used_seo = JSON.parse(brand['used_seotext'])

  hash = b.description.to_h
  hash[:used_seotext_upper] = used_seo[0]['Seotextblock']
  hash[:used_seotext_lower] = used_seo[1]['Seotextblock']
  b.description = hash
  b.save!
end
puts 'used_brand end'


puts 'blog start'
blogs = JSON.parse(File.read(Rails.root + 'db/assets/blog.json'))
blogs.each do |blog|
  b = Blog.new
  brand = Brand.find_by(url: blog["brand_url"])
  if brand.present?
    b.brand_id = brand.id
  end

  car = NewCar.find_by(url: blog["car_url"])
  if car.present?
    b.new_car_id = car.id
  end

  # img_arr = ['intro_text.jpg','design1.jpg','design2.jpg','construction.jpg','adapt.jpg','comfort1.jpg','comfort2.jpg','security.jpg','media.jpg','stats.jpg','size.png']
  # b[:images] = img_arr

  desc = {}

  text = Nokogiri::HTML(blog["content"])

  desc['intro_text'] = text.css('p').first.content

  desc['procontra_text'] = text.css('p').last.content

  text.css('ul').each do |list|
    if list.at_css('b').present?
      if (list.at_css('b').content.include? 'плюс') || (list.at_css('b').content.include? 'понравится ')
        desc['pro_text'] = list.at_css('b').content
        desc['pro'] = []
        list.css('li').each do |li|
          desc['pro'].push(li.content)
        end
        next
      end

      if (list.at_css('b').content.include? 'минус') || (list.at_css('b').content.include? 'не лучшее')|| (list.at_css('b').content.include? 'не понравится')
        desc['contra_text'] = list.at_css('b').content
        desc['contra'] = []
        list.css('li').each do |li|
          desc['contra'].push(li.content)
        end
        next
      end
    end
  end

  text.css('div').each do |section|
    if section.at_css('h2').present?
      if section.at_css('h2').content === 'Дизайн'
        desc['design'] = []
        section.css('p').each do |p|
          desc['design'].push(p.content)
        end

        next
      end

      if section.at_css('h2').content === 'Конструкция'
        desc['construction'] = []
        section.css('p').each do |p|
          desc['construction'].push(p.content)
        end
        if desc['construction'].empty?
          section.at_css('h2').remove
          desc['construction'].push(section.content)
        end
        next
      end

      if section.at_css('h2').content.include? 'российским'
        desc['adapt'] = []
        section.css('p').each do |p|
          desc['adapt'].push(p.content)
        end
        if desc['adapt'].empty?
          section.at_css('h2').remove
          desc['adapt'].push(section.content)
        end
        next
      end

      if section.at_css('h2').content === 'Комфорт'
        desc['comfort'] = []
        section.css('p').each do |p|
          desc['comfort'].push(p.content)
        end
        next
      end

      if section.at_css('h2').content === 'Безопасность'
        desc['security'] = []
        section.css('p').each do |p|
          desc['security'].push(p.content)
        end
        next
      end

      if section.at_css('h2').content === 'Мультимедиа' || section.at_css('h2').content === 'Развлекательные системы' || section.at_css('h2').content === 'Аудиосистемы и климат-контроль' || section.at_css('h2').content === 'Климат-контроль и аудиосистема'
        desc['media'] = []
        section.css('p').each do |p|
          desc['media'].push(p.content)
        end
        next
      end


      if section.at_css('h2').content.include? 'характеристики'
        desc['stats'] = []
        section.css('p').each do |p|
          desc['stats'].push(p.content)
        end
        next
      end

    end
  end

  b.description = desc
  b.url = blog["alias"]
  b.save


  result = []
  result_files = []
  flag = true
  img_arr = ['intro_text.jpg','design1.jpg','design2.jpg','construction.jpg','adapt.jpg','comfort1.jpg','comfort2.jpg','security.jpg','media.jpg','stats.jpg','size.jpg']

  img_arr.each do |img|
    file_name = img
    path_to_file = Rails.root.join("public/uploads/blog/#{b.id}/images/#{file_name}")

    unless File.exist?(path_to_file)
      flag = false
      puts file_name
    end

    file = Rails.root.join("public/tmp/blogs/#{car.id}/#{img}").open
    result_files.push(file)
    result.push(file_name)
  end

  if flag
    b['images'] = result
    # c.images360 = result_files
  else
    puts "not exist #{car.id}".red
    b['images'] = result
    # b.images = result_files
  end

  b.save

end


puts 'blog end'

finish = Time.now
diff = finish - start
puts 'Заняло: '
puts diff