class HsaController < ApplicationController

  def index
    @locations = Ohanakapa.locations(:page => params[:page], :per_page => 40)
  end

  def show
    @location = Ohanakapa.location(params[:id])
    @categories_raw = Ohanakapa.cats

    # sort OE taxonomy by ID
    @sorted_cat = @categories_raw.sort_by { |k| k["oe_id"] }

    @categories = Hash.new
    @categories['top_level'] = []
    top_len = 0
    second_len = 0
    @sorted_cat.each do |cat|

      if cat.oe_id.count('-') == 0
        @categories['top_level'].push({'id'=>cat.id,'title'=>cat.name})
        top_len = @categories['top_level'].length-1
      elsif cat.oe_id.count('-') == 1
        if @categories['top_level'][top_len]['second_level'].blank?
          @categories['top_level'][top_len]['second_level'] = []
        end
        @categories['top_level'][top_len]['second_level'].push({'id'=>cat.id,'title'=>cat.name})
      elsif cat.oe_id.count('-') == 2
        second_len = 0
        if @categories['top_level'][top_len]['second_level'][second_len]['third_level'].blank?
          @categories['top_level'][top_len]['second_level'][second_len]['third_level'] = []
        end
        @categories['top_level'][top_len]['second_level'][second_len]['third_level'].push({'id'=>cat.id,'title'=>cat.name})
        second_len = @categories['top_level'][top_len]['second_level'].length-1
      end

    end

    # returns the constructed categories list HTML to the view
    @cat_html = _traverse(@categories['top_level'])

  end

  def edit_services
    keywords = [params[:keyword1], params[:keyword2], params[:keyword3], params[:keyword4]].delete_if {|k| k.empty?}
    id = params[:id]
    cat_ids = params[:category_ids]

    Ohanakapa.post("services/#{id}/keywords", :query => { :keywords => keywords }) unless keywords.empty?
    Ohanakapa.put("services/#{id}/categories", :query => { :category_ids => cat_ids }) if cat_ids

    redirect_to "#{root_url}?page=#{params[:page]}"
  end

  private

  # traverses the three levels. Could really use recursion here.
  def _traverse(data)
    opt = ''
    data.each do |item|
      _add_id(item)
      opt += "<li class='depth0'><label><input id=\"category_ids[]\" name=\"category_ids[]\" type='checkbox' value=\"#{item['id']}\">#{item['title']}</label>"
      if item['second_level']
        opt += "<ul>"
        opt += _traverse2(item['second_level'],item['title'])
        opt += "</ul>"
      end
      opt += "</li>"
    end
    opt.html_safe
  end

  def _traverse2(data,toptitle)
    opt = ''
    data.each do |item|
      _add_id(item)
      opt += "<li class='hide depth1'><label><input id=\"category_ids[]\" name=\"category_ids[]\" type='checkbox' value=\"#{item['id']}\">#{item['title']}</label>"
      if item['third_level']
        opt += "<ul>".html_safe
        opt += _traverse3(item['third_level'],toptitle,item['title'])
        opt += "</ul>".html_safe
      end
      opt += "</li>"
    end
    opt
  end

  def _traverse3(data,toptitle,secondtitle)
    opt = ''
    data.each do |item|
      _add_id(item)
      opt += "<li class='hide depth2'><label><input id=\"category_ids[]\" name=\"category_ids[]\" type='checkbox' value=\"#{item['id']}\">#{item['title']}</label></li>"
    end
    opt
  end

  # adds the database ids to the hardcoded category hierarchy
  def _add_id(item)
    @categories_raw.each do |cat|
      if (cat.oe_id.to_s == item['id'].to_s)
        item['id'] = cat.id
      end
    end
  end


end