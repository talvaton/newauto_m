# start = Time.now
#
# puts 'region start'
# regions = JSON.parse(File.read(Rails.root + 'db/assets/regions.json'))
# regions.each do |region|
#   reg = Region.new
#   reg.name = region['name']
#   reg.sklon1 = region['sklon1']
#   reg.sklon2 = region['sklon2']
#   reg.sklon3 = region['sklon3']
#   reg.save!
# end
# puts 'region end'

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
  # if File.exist?(path_to_file)
  #   b['image'] = bank['image']
  # else
  b.image = Rails.root.join("app/assets/images/centr/banks/" + bank['image']).open
  # end

  b.save!
end
puts 'bank end'
#
# puts 'brand start'
# brands = JSON.parse(File.read(Rails.root + 'db/assets/brands.json'))
# brands.each do |brand|
#   b = Brand.new
#   b.title = brand['title']
#   b.menutitle = brand['menutitle']
#   b.url = brand['url']
#
#   desc = {}
#   if brand['brand_desc'].present?
#     desc[:brand_desc] = brand['brand_desc']
#   end
#
#   if brand['brand_seotext'].present?
#     brand_seo = JSON.parse(brand['brand_seotext'])
#
#     b_seo = []
#     brand_seo.each do |seo|
#       b_seo.push(seo['Seotextblock'].gsub('/Сhery/','/Chery/').gsub('/UAZ/','/Uaz/').gsub('/KIA/','/Kia/').gsub('/Сitroen/','/Citroen/'))
#     end
#
#     desc[:brand_seotext] = b_seo.join('')
#     # puts desc
#   end
#   b.description = desc
#
#   if brand['published'] == 1
#     b.hide = false
#   else
#     b.hide = true
#   end
#
#   if brand['official'] == 1
#     b.official = true
#   else
#     b.official = false
#   end
#
#   if brand['hide'] == 1
#     b.menu_show = 0
#   else
#     b.menu_show = 1
#   end
#
#   #logos
#   b.save!
#
#
#   # Work with Brand images
#
#   #cert
#   if brand['cert']
#     path_to_file = Rails.root.join("public/uploads/brand/cert/#{brand['cert'].gsub('assets/images/sert/','')}")
#     if File.exist?(path_to_file)
#       b['cert'] = brand['cert'].gsub('assets/images/sert/','')
#     else
#       b.cert = Rails.root.join("public/tmp/brand_cert/" + brand['cert'].gsub('assets/images/sert/','')).open
#     end
#   end
#
#   #logo
#   path_to_file = Rails.root.join("public/uploads/brand/logo/#{brand['logo'].gsub('assets/images/logo/','')}")
#   if File.exist?(path_to_file)
#     b['logo'] = brand['logo'].gsub('assets/images/logo/','')
#     b['logoblack'] = brand['logoblack'].gsub('assets/images/logo/','')
#   else
#     b.logo = Rails.root.join("public/tmp/brand_logo/" + brand['logo'].gsub('assets/images/logo/','')).open
#     b.logoblack = Rails.root.join("public/tmp/brand_logo/" + brand['logoblack'].gsub('assets/images/logo/','')).open
#   end
#
#   b.save!
# end
# puts 'brand end'
#
# puts 'news start'
# newslist = JSON.parse(File.read(Rails.root + 'db/assets/news.json'))
# newslist.each do |news_item|
#   ni = Story.new
#   ni.name = news_item['pagetitle']
#   content = news_item['content']
#   ni.newstext = content.gsub('/assets/images/', '/tmp/')
#   # ni.newsImage = Rails.root.join("public/tmp/news/" + news_item['newsImage']).open
#   ni[:newsImage] = '1.jpg'
#   if news_item['brand'].present?
#     brand = Brand.where(title: news_item['brand'].gsub('ВАЗ','Lada').gsub('Uaz','Уаз').gsub('Vaz','Lada')).first_or_create!
#     ni.brand_id = brand.id
#   end
#   ni.created_at = Time.at(news_item['createdon'])
#   ni.url = news_item['alias']
#
#   ni.save!
# end
# puts 'news end'
#
#
# puts 'reviews start'
# reviews = JSON.parse(File.read(Rails.root + 'db/assets/reviews.json'))
# reviews.each do |rev|
#   review = Review.new
#   review.name = rev['name']
#   review.rev_text = rev['reviewtext']
#   review[:image] = '1.JPG'
#   # review.image = Rails.root.join("public/tmp/reviews/" + rev['image']).open
#   review.created_at = rev['date']
#
#   review.save!
# end
# puts 'reviews end'
#
# puts 'usedcars start'
# used_cars = JSON.parse(File.read(Rails.root + 'db/assets/used_cars.json'))
# used_cars.each do |car|
#   c = UsedCar.new
#   c.id = car['id']
#   c.name = car['model']
#   brand = Brand.where(title: car['brand']).first_or_create! do |brand|
#     brand.hide = 1
#   end
#   c.brand = brand
#   c.price = car['price']
#   c.odometer = car['odometer']
#   c.year = car['year']
#   c.vin = car['vin']
#   if car['avito'] == 1
#     c.avito = true
#   else
#     c.avito = false
#   end
#   if car['published'] == 1
#     c.hide = false
#   else
#     c.hide = true
#   end
#   c.car_type = car['type']
#
#   img_array = ['image_1.jpg','image_2.jpg','image_3.jpg']
#   c[:images] = img_array
#   # if car['images']
#   #   images = JSON.parse car['images']
#   #   result = []
#   #   images.each do |img|
#   #     file = Rails.root.join("public/tmp/photo_used/" + img['imagepath']).open
#   #     result.push(file)
#   #   end
#   #   c.images = result
#   # end
#
#   if car['parameters']
#     params = JSON.parse car['parameters']
#     params.each do |param|
#       c.owners = param['owners']
#       c.condition = param['status']
#       c.color = param['color']
#       c.transmission = param['transmission']
#       c.volume = param['engine_volume']
#       c.power = param['power']
#       c.drive = param['drive']
#       compl_h = {}
#       compl_h[:steer] = param['steer']
#       compl_h[:enginetype] =  param['engine_type']
#       compl_h[:interior] = param['interior']
#       compl_h[:interior_color] = param['interior_color']
#       compl_h[:driverseatreg] = param['driverseatreg']
#       compl_h[:passengerseatreg] = param['passengerseatreg']
#       compl_h[:steerreg] = param['steerreg']
#       compl_h[:climatcontrol] = param['climatcontrol']
#       compl_h[:airbag] = param['airbag']
#       compl_h[:multimedia] = param['multimedia']
#       compl_h[:power_window] = param['power_window']
#       compl_h[:power_steering] = param['power_steering']
#       compl_h[:other] = param['complect']
#       c.complectation = compl_h
#     end
#   end
#
#   c.used = true
#   c.save!
# end
# puts 'usedcars end'
#
#
# puts 'specialcars start'
# special_cars = JSON.parse(File.read(Rails.root + 'db/assets/special_cars.json'))
# special_cars.each do |car|
#   c = UsedCar.new
#   c.id = car['id']
#   c.name = car['model']
#   c.menutitle = car['menutitle']
#   brand = Brand.where(title: car['brand']).first_or_create! do |brand|
#     brand.hide = 1
#   end
#
#   c.brand = brand
#   c.price = car['price']
#   c.year = car['year']
#   c.vin = car['vin']
#   if car['avito'] == 1
#     c.avito = true
#   else
#     c.avito = false
#   end
#   c.color = car['color']
#   c.car_type = car['type']
#
#   img_array = ['image_1.jpg','image_2.jpg','image_3.jpg']
#   c[:images] = img_array
#
#   # if car['images']
#   #   images = JSON.parse car['images']
#   #   result = []
#   #   images.each do |img|
#   #     file = Rails.root.join("public/tmp/photo_used/" + img['imagepath']).open
#   #     result.push(file)
#   #   end
#   #   c.images = result
#   # end
#
#   if car['parameters']
#     params = JSON.parse car['parameters']
#     params.each do |param|
#       c.transmission = param['transmission']
#       c.volume = param['engine_volume']
#       c.power = param['power']
#       c.drive = param['drive']
#
#       compl_h = {}
#       compl_h[:other] = param['complect']
#       c.complectation = compl_h
#     end
#   end
#
#   if car['published'] == 1
#     c.hide = false
#   else
#     c.hide = true
#   end
#   c.used = false
#   c.save!
# end
# puts 'specialcars end'
#
# puts 'new cars start'
# cars = JSON.parse(File.read(Rails.root + 'db/assets/cars.json'))
# cars.each do |car|
#   c = NewCar.new
#   c.id = car['id']
#   b = Brand.find_by(url: car['brand_name'])
#   c.brand = b
#   c.name = car['name']
#   c.russian_name = car['russian_name']
#   c.menutitle = car['menutitle']
#   # c.description = car['description']
#   c.url = car['alias']
#   if car['alias'].end_with? 'old'
#     c.old = true
#   end
#
#
#
#   # puts car['published']
#   if car['published'] == 1
#     c.hide = false
#   else
#     c.hide = true
#   end
#   c.discount = car['discount']
#   c.discount_credit = car['discount_credit']
#   c.discount_tradein = car['discount_tradein']
#   if car['half_discount']
#     c.half_discount = true
#   end
#   c.car_type = car['car_type']
#
#   if car['car_link']
#     cl = JSON.parse car['car_link']
#     result = []
#     cl.each do |s|
#       result.push(s['car'])
#     end
#     c.car_link = result
#   end
#
#   c.country = car['country']
#   c.warranty = car['warranty']
#
#   if car['special_options']
#     so = car['special_options']
#     c.special_options = so.split('||')
#   end
#
#   c.video_link = car['video_link']
#
#
#
#   if car['seo_text']
#     st = JSON.parse car['seo_text']
#     result = {}
#     lower_t = []
#
#
#
#     doc = Nokogiri::HTML(st[0]['Seotextblock'])
#     doc.css('div').each_with_index do |d,index|
#       if index == 0
#         result[:text_upper] = d.children.to_html
#       else
#         lower_t.push(d.to_html)
#       end
#     end
#     if lower_t.present?
#       result_lower_t = lower_t.join
#                            .gsub('assets/images/img_text/', '/static/images/img_text/')
#                            .gsub('"catalog/', '"/catalog/')
#                            .gsub('/%D0%A1hery/','/Chery/')
#                            .gsub('/UAZ/','/Uaz/')
#                            .gsub('/KIA/','/Kia/')
#                            .gsub('/%D0%A1itroen/','/Citroen/')
#       result[:text_lower] = result_lower_t
#     end
#
#     c.description = result
#   end
#
#   color_arr = ['1_Белый_Перламутр.png','2_Белый.png','3_Темно-серый.png','4_Темно-красный.png','5_Черный.png','6_Серебристый.png','7_Синий.png']
#   c[:colors] = color_arr
#
#   if car['colors'] && car['published'] != 0
#     colors = JSON.parse car['colors']
#     # result = []
#     options = []
#     colors.each do |col|
#       # file = Rails.root.join("public/tmp/newcars/" + car['id'].to_s + "/colors/" + col['photo']).open
#       opt = {colorname: col['colorname'],color: col['color'],color2: col['color_2']}
#       # result.push(file)
#       options.push(opt)
#     end
#     # puts JSON.parse result
#     # c.colors = result
#     c.color_options = options
#   end
#
#   images_arr = ['image_2758.jpg','image_2759.jpg','image_2760.jpg','image_2762.jpg','image_2766.jpg','image_2767.jpg','image_2768.jpg','image_2769.jpg','image_2770.jpg','image_2771.jpg','image_2775.jpg','image_2777.jpg']
#   c[:images] = images_arr
#
#   # if car['NewImageList'] && car['published'] != 0
#   #   images = JSON.parse car['NewImageList']
#   #   result = []
#   #   images.each do |img|
#   #     file = Rails.root.join("public/tmp/newcars/" + car['id'].to_s + "/photo/" + img['imagepath']).open
#   #     result.push(file)
#   #   end
#   #   c.images = result
#   # end
#   if car['View360'] && car['published'] != 0
#     images360_arr = ['1.png','2.png','3.png','4.png','5.png','6.png','7.png','8.png','9.png','10.png','11.png','12.png','13.png','14.png','15.png','16.png','17.png','18.png','19.png','20.png','21.png','22.png','23.png','24.png','25.png','26.png','27.png','28.png','29.png','30.png','31.png','32.png','33.png','34.png','35.png','36.png']
#     c[:images360] = images360_arr
#   end
#
#   c[:images] = images_arr
#   # if car['View360'] && car['published'] != 0
#   #   view = JSON.parse car['View360']
#   #   result = []
#   #   view.each do |img|
#   #     file = Rails.root.join("public/tmp/newcars/" + car['id'].to_s + "/360/" + img['image']).open
#   #     result.push(file)
#   #   end
#   #   c.images360 = result
#   # end
#
#   c.save!
# end
# puts 'new cars end'
#
#
# puts 'spec start'
# specifications = JSON.parse(File.read(Rails.root + 'db/assets/specifications.json'))
# specifications.each do |spec|
#   if spec['specifications'].present?
#     tech = JSON.parse(spec['specifications'])
#     tech.each do |t|
#       s = Specification.new
#       s.new_car = NewCar.find(spec['id'])
#       s.name = t['name']
#       s.enginetype = t['enginetype']
#       s.volume = t['volume']
#       s.power = t['power']
#       s.acceleration = t['acceleration']
#       s.topspeed = t['topspeed']
#
#       s.fuelcity = t['fuelcity']
#       s.fuelhigh = t['fuelhigh']
#       s.fuelmix = t['fuelmix']
#       s.tank = t['tank']
#
#       s.length = t['length']
#       s.width = t['width']
#       s.height = t['height']
#       s.wheelbase = t['wheelbase']
#       s.clearance = t['clearance']
#       s.mass = t['mass']
#       s.trunk = t['trunk']
#       s.transmission = t['transmission']
#       s.shorttransmission = t['shorttransmission']
#       s.drive = t['drive']
#       s.frontsusp = t['frontsusp']
#       s.rearsusp = t['rearsusp']
#       s.frontbrakes = t['frontbrakes']
#       s.rearbrakes = t['rearbrakes']
#
#       s.save!
#     end
#   end
#   if spec['equipment_description'].present?
#     desc = JSON.parse(spec['equipment_description'])
#     desc.each do |d|
#       # puts d['Published']
#       if d['Published'] != '1'
#         ed = EquipmentDescription.new
#         ed.name = d['compldescname']
#         ed.description = d['description']
#         ed.new_car = NewCar.find(spec['id'])
#         ed.save!
#       end
#     end
#   end
#   if spec['equipment'].present?
#     equip = JSON.parse(spec['equipment'])
#     equip.each do |e|
#       sp_id = Specification.where(new_car_id: spec['id'])
#       ed = EquipmentDescription.where(name: e['complname']).where(new_car_id: spec['id'])
#       if sp_id.present? && ed.present?
#         eq = Equipment.new
#         # sp_id = Specification.where(new_car_id: spec['id'])
#         eq.specification = sp_id[e['tech'].to_i - 1]
#         # puts ed.id
#         # debugger
#         eq.equipment_description = ed.first
#         eq.price = e['price']
#         eq.suffix = e['suffix']
#
#         eq.save!
#       end
#     end
#   end
# end
# puts 'spec end'
#
# puts 'used_brand start'
# ubrands = JSON.parse(File.read(Rails.root + 'db/assets/used_brands.json'))
# ubrands.each do |brand|
#   b = Brand.find_or_initialize_by(title: brand["title"])
#
#   # puts brand['used_seotext']
#   used_seo = JSON.parse(brand['used_seotext'])
#
#
#   hash = b.description.to_h
#   hash[:used_seotext_upper] = used_seo[0]['Seotextblock']
#   hash[:used_seotext_lower] = used_seo[1]['Seotextblock']
#   b.description = hash
#   b.save!
# end
# puts 'used_brand end'
#
#
# puts 'blog start'
# blogs = JSON.parse(File.read(Rails.root + 'db/assets/blog.json'))
# blogs.each do |blog|
#   b = Blog.new
#   brand = Brand.find_by(url: blog["brand_url"])
#   if brand.present?
#     b.brand_id = brand.id
#   end
#
#   car = NewCar.find_by(url: blog["car_url"])
#   if car.present?
#     b.new_car_id = car.id
#   end
#
#   img_arr = ['intro_text.jpg','design1.jpg','design2.jpg','construction.jpg','adapt.jpg','comfort1.jpg','comfort2.jpg','security.jpg','media.jpg','stats.jpg','size.png']
#   b[:images] = img_arr
#
#   desc = {}
#
#   text = Nokogiri::HTML(blog["content"])
#
#   desc['intro_text'] = text.css('p').first.content
#
#   desc['procontra_text'] = text.css('p').last.content
#
#   text.css('ul').each do |list|
#     if list.at_css('b').present?
#       if list.at_css('b').content.include? 'плюс'
#         desc['pro_text'] = list.at_css('b').content
#         desc['pro'] = []
#         list.css('li').each do |li|
#           desc['pro'].push(li.content)
#         end
#         next
#       end
#
#       if list.at_css('b').content.include? 'минус'
#         desc['contra_text'] = list.at_css('b').content
#         desc['contra'] = []
#         list.css('li').each do |li|
#           desc['contra'].push(li.content)
#         end
#         next
#       end
#     end
#   end
#
#   # desc['pro'] = text.css('ul')[1].to_html
#   # desc['contra'] = text.css('ul')[2].to_html
#
#   text.css('div').each do |section|
#     if section.at_css('h2').present?
#       if section.at_css('h2').content === 'Дизайн'
#         desc['design'] = []
#         section.css('p').each do |p|
#           desc['design'].push(p.content)
#         end
#
#         next
#       end
#
#       if section.at_css('h2').content === 'Конструкция'
#         desc['construction'] = []
#         section.css('p').each do |p|
#           desc['construction'].push(p.content)
#         end
#         if desc['construction'].empty?
#           section.at_css('h2').remove
#           desc['construction'].push(section.content)
#         end
#         next
#       end
#
#       if section.at_css('h2').content.include? 'российским'
#         desc['adapt'] = []
#         section.css('p').each do |p|
#           desc['adapt'].push(p.content)
#         end
#         if desc['adapt'].empty?
#           section.at_css('h2').remove
#           desc['adapt'].push(section.content)
#         end
#         next
#       end
#
#       if section.at_css('h2').content === 'Комфорт'
#         desc['comfort'] = []
#         section.css('p').each do |p|
#           desc['comfort'].push(p.content)
#         end
#         next
#       end
#
#       if section.at_css('h2').content === 'Безопасность'
#         desc['security'] = []
#         section.css('p').each do |p|
#           desc['security'].push(p.content)
#         end
#         next
#       end
#
#       if section.at_css('h2').content === 'Мультимедиа' || section.at_css('h2').content === 'Развлекательные системы' || section.at_css('h2').content === 'Аудиосистемы и климат-контроль' || section.at_css('h2').content === 'Климат-контроль и аудиосистема'
#         desc['media'] = []
#         section.css('p').each do |p|
#           desc['media'].push(p.content)
#         end
#         next
#       end
#
#
#       if section.at_css('h2').content.include? 'характеристики'
#         desc['stats'] = []
#         section.css('p').each do |p|
#           desc['stats'].push(p.content)
#         end
#         next
#       end
#
#     end
#   end
#
#   b.description = desc
#   b.url = blog["alias"]
#   b.save
# end
# puts 'blog end'
#
# finish = Time.now
# diff = finish - start
# puts 'Заняло: '
# puts diff