class SitemapController < ApplicationController
  def show
    render file: "public/sitemaps/#{params[:region]}/sitemap.xml"
  end
end
