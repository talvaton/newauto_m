namespace :data do
  desc %Q{ Copy images from salon_admin to current public}
  task :images_dev do
    on roles(:app) do
      execute "cp -r /var/www/salon_web_admin/public/uploads /var/www/rcar_staging/shared/public/"
    end
  end

  desc %Q{ Copy images from salon_admin to current public}
  task :images do
    on roles(:app) do
      execute "cp -r /var/www/salon_web_admin/public/uploads /var/www/rcar_production/shared/public/"
    end
  end

  desc %Q{ Copy database from rcar_dev to rcar_prod}
  task :database do
    on roles(:app) do
      execute "mysqldump --defaults-file=~/.my.cnf salon_web_development --ignore-table=salon_web_development.tickets  > ~/swd.sql && mysql --defaults-file=~/.my.cnf -h localhost salon_web_production < ~/swd.sql"
    end
  end

  desc 'clear rails cache'
  task :clear do
    on roles(:app) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, "rake cache:clear"
        end
      end
    end
  end

  desc 'convert to webp'
  task :webp_convert do
    on roles(:app) do
      execute 'for i in $(find /var/www/carso_production/shared/public/ -type f \( -iname "*.jpg" -o -iname "*.png" \)); do cwebp -q 60 "$i" -o "${i}".webp; done'
      # 'for i in $(find /var/www/carso_staging/shared/public/assets -type f \( -iname "*.jpg" -o -iname "*.png" \)); do cwebp -q 60 "$i" -o "${i}".webp; done'
    end
  end
end