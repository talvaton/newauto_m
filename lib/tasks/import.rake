namespace :import do

  desc %Q{ import everything }
  task :new_cars_seo  => :environment do
    cars = JSON.parse(File.read(Rails.root + 'db/assets/new_cars_seo.json'))
    cars.each do |c|
      car = NewCar.find_by(url: c['url'])
      if car.present?
        car.description['text_lower'] = c['text_lower']
        car.description['text_upper'] = c['text_upper']
        car.save!
      else
        puts "Не найдено #{c['url']}"
      end
    end
  end


  desc %Q{ import everything }
  task :articles  => :environment do
    cars = JSON.parse(File.read(Rails.root + 'db/assets/articles.json'))
    cars.each do |c|
        Articles.create!(c)
      end
   end

  desc %Q{ import everything }
  task :overviews  => :environment do
    cars = JSON.parse(File.read(Rails.root + 'db/assets/overview.json'))
    cars.each do |c|
      Overviews.create!(c)
    end
  end

  desc %Q{ import everything }
  task :everything  => :environment do
    require 'csv'


    ed_file_path = "#{Rails.root}/db/updates/equipment_description.csv"
    s_file_path = "#{Rails.root}/db/updates/specifications.csv"
    e_file_path = "#{Rails.root}/db/updates/equipment.csv"
    r_file_path = "#{Rails.root}/db/updates/review.csv"
    nc_file_path = "#{Rails.root}/db/updates/newcar.csv"


    puts 'importing cars'
    CSV.foreach(nc_file_path,headers: true) do |row|
      NewCar.where(id: row['id']).first_or_initialize.tap do |e|
        e.hide = row['hide']
        # row_hash = row.to_h
        # puts row_hash
        # puts row_hash.class
        # row['description'] = ''
        # e.attributes = row.to_h
        e.save!
      end
    end

    puts 'ED'
    CSV.foreach(ed_file_path,headers: true) do |row|
      EquipmentDescription.where(id: row['id']).first_or_initialize.tap do |e|
        e.attributes = row.to_h
        e.save!
      end
    end

    puts 'Specification'
    CSV.foreach(s_file_path,headers: true) do |row|
      Specification.where(id: row['id']).first_or_initialize.tap do |e|
        e.attributes = row.to_h
        e.save!
      end
    end

    puts 'Equipment'
    CSV.foreach(e_file_path,headers: true) do |row|
      Equipment.where(id: row['id']).first_or_initialize.tap do |e|
        e.attributes = row.to_h
        e.save!
      end
    end

    puts 'Reviews'
    CSV.foreach(r_file_path,headers: true) do |row|
      Review.where(id: row['id']).first_or_initialize.tap do |e|
        e.attributes = row.to_h
        e.save!
      end
    end


    # csv_text = File.read(e_file_path)
  end

  # desc %Q{ import prices }
  # task :prices  => :environment do
  #   require 'csv'
  #
  #   file_path = "#{Rails.root}/db/updates/equipment_#{Date.today}.csv"
  #
  #   csv_text = File.read(file_path)
  #   csv = CSV.parse(csv_text, :headers => false)
  #   csv.each do |row|
  #     e = Equipment.find(row[0])
  #     e.price = row[1]
  #     # suffix пока не меняем
  #     # e.suffix = row[2]
  #     e.save!
  #   end
  # end
  #
  #
  # desc %Q{ import reviews }
  # task :reviews  => :environment do
  #   require 'csv'
  #
  #   file_path = "#{Rails.root}/db/updates/reviews_#{Date.today}.csv"
  #
  #   csv_text = File.read(file_path)
  #   csv = CSV.parse(csv_text, :headers => false)
  #   csv.each do |row|
  #     # puts row[0]
  #     #
  #     rev = Review.find_or_create_by(id: row[0])
  #     rev.id = row[0]
  #     rev.name = row[1]
  #     rev.rev_text = row[2]
  #     rev.new_car_id = row[3]
  #     rev["image"] = row[4]
  #     rev.created_at = row[5]
  #     rev.save!
  #   end
  # end

end