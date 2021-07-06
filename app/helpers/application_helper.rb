module ApplicationHelper
  def javascript_exists?(script)
    script = "#{Rails.root}/app/assets/javascripts/"+script
    File.exists?("#{script}.js") || File.exists?("#{script}.coffee")
  end

  def stylesheet_exists?(stylesheet)
    stylesheet = "#{Rails.root}/app/assets/stylesheets/"+stylesheet
    File.exists?("#{stylesheet}.css") || File.exists?("#{stylesheet}.scss")
  end

  def main_page?
    if action_name == 'main'
      true
    else
      false
    end
  end

  def credit_page?
    url = request.path_info
    if url.include?('credit')
      true
    else
      false
    end
  end

  def tradein_page?
    url = request.path_info
    if url.include?('tradein')
      true
    else
      false
    end
  end
  def taxi_page?
    url = request.path_info
    if url.include?('taxi')
      true
    else
      false
    end
  end

  def svg_tag(image,symbol,width,height,options={})
    options = options.symbolize_keys
    content_tag(:svg, width: "#{width}",height: "#{height}",class: options[:class],id:options[:id]) do
      content_tag(:use, nil, 'href' => "#{image_path(image)}##{symbol}", 'xlink:href' => "#{image_path(image)}##{symbol}")
    end
  end

  def image_set_tag(source, srcset = {}, options = {})
    srcset = srcset.map { |src, size| "#{path_to_image(src)} #{size}" }.join(', ')
    image_tag(source, options.merge(srcset: srcset))
  end



end
