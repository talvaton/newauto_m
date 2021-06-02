namespace :server do

  desc %Q{ Run Rails in production and in daemon }
  task :start => :environment do
    sh %{puma -e #{Rails.env} -d -b unix:///tmp/salon_web.sock --pidfile /tmp/puma.pid -t 8:8 -w 4}
  end

  # desc %Q{ Run Rails in development }
  # task :startdev do
  #   sh %{puma -e development -b unix:///tmp/salon_web.sock --pidfile /tmp/pumadev.pid -p 3000}
  # end

  desc %Q{ Stop rails in production }
  task :stop => :environment do
    pid_file = Rails.root + '/tmp/puma.pid'
    pid = File.read(pid_file).to_i
    Process.kill 9, pid
    File.delete pid_file
  end

  desc %Q{ Restart server }
  task :restart => :environment do
    pid_file = Rails.root + '/tmp/puma.pid'
    pid = File.read(pid_file).to_i
    Process.kill 9, pid
    File.delete pid_file

    sh %{puma -e #{Rails.env} -d -b unix:///tmp/salon_web.sock --pidfile /tmp/puma.pid  -t 8:8 -w 4}
  end
end

