# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.scss, and all non-JS/CSS in the app/assets
# folder are already added.

# Rails.application.config.assets.precompile += %w(brands.js deals.js  new_cars.js  reviews.js  static_pages.js  used_cars.js)
# Rails.application.config.assets.precompile += %w(brands.css deals.css new_cars.css reviews.css static_pages.css used_cars.css)

# Rails.application.
# SVG


# config.assets.precompile += %w( *.svg )
# config.assets.precompile += %w( *.jpeg )
# Rails.application.config.assets.precompile += %w(*.jpeg)

  Rails.application.config.assets.precompile += %w(carso/main.css carso/carso.css carso/carso_main.css carso/carso_main.js carso/centr.js carso/carso_corporate.css carso/carso_do.css carso/carso_do_type.css carso/brands.css carso/brands_index.css carso/brands_show.css carso/brands_show_credit.css carso/brands_show_tradein.css carso/brands.js carso/brands_show_credit.js carso/banks.css carso/finances.css carso/brands_show_taxi.css)
  Rails.application.config.assets.precompile += %w(carso/new_cars.css carso/new_cars_show_brand_type.css carso/new_cars.js carso/new_cars_show.js carso/new_cars_show_credit.css carso/new_cars_show_tradein.css carso/new_cars_show_taxi.css carso/new_cars_show_credit.js carso/new_cars_show_tradein.js carso/new_cars_show_taxi.js carso/new_cars_show_color.js carso/new_cars_show_equipment.js carso/new_cars_show_configurator.css carso/new_cars_show_configurator.js carso/new_cars_country.css carso/new_cars_type.css carso/new_cars_show_equipment.css  carso/new_cars_show_equipment_id.css)
  Rails.application.config.assets.precompile += %w(carso/used_cars.css carso/used_cars_used.js carso/used_cars_used_brand.js carso/used_cars_used_brand_model.js carso/used_cars_used_brand_model_year.js carso/used_cars_used_brand_year.js carso/used_cars_used_country.js carso/used_cars_used_price.js carso/used_cars_used_transmission.js carso/used_cars_used_type.js carso/used_cars_used_year.js)
  Rails.application.config.assets.precompile += %w(carso/used_cars_special.js carso/carso_topsales.css carso/carso_family_auto.css carso/carso_first_auto.css carso/carso_family_auto.js carso/carso_first_auto.js carso/carso_medical_auto.js carso/carso_medical_auto.css)
  Rails.application.config.assets.precompile += %w(carso/carso_tradein.css carso/carso_tradein.js  carso/carso_utilization.css carso/carso_credit.css carso/carso_credit.js carso/carso_stock.css carso/banks.js carso/finances.js carso/carso_sell.scss)
  Rails.application.config.assets.precompile += %w(carso/reviews.css carso/reviews_model.css carso/reviews_show.css carso/reviews.js carso/reviews_model.js carso/stories.css carso/carso_contacts.css carso/carso_contacts.js carso/blog.css carso/blog_show.css carso/blog_show.js carso/errors.css)
  Rails.application.config.assets.precompile += %w(carso/carso_service.css carso/carso_service.js)