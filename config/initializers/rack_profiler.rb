# frozen_string_literal: true

if Rails.env.salon_dev? || Rails.env.rcar_dev?
  require "rack-mini-profiler"

  # initialization is skipped so trigger it
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
