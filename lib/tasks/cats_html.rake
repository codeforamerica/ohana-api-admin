require 'json'

task :cats2html => :environment do
  puts "==============================================================="
  puts "Creating html for categories based on OpenEligibility Taxonomy"
  puts "==============================================================="

  @categories ||= Ohanakapa.cats
  @depth_0 ||= @categories.select { |cat| cat.depth == 0 }.sort_by(&:oe_id)

  def children(category)
    Ohanakapa.get("categories/#{category.oe_id}/children")
  end

  cat_html = ""

  @depth_0.each do |d0|
    cat_html << "
    %li.depth0
      = check_box_tag \"category_#{d0.oe_id}\", \"#{d0.oe_id}\", service[:categories].present? && oe_ids.include?(\"#{d0.oe_id}\") ? true : false, :name => \"oe_ids[]\"
      %label
        = \"#{d0.name}\""
    @children_0 = children(d0)
    if @children_0.present?
      cat_html << "
      %ul"
    end
    @children_0.each do |d1|
      cat_html << "
        %li.hide.depth1
          = check_box_tag \"category_#{d1.oe_id}\", \"#{d1.oe_id}\", service[:categories].present? && oe_ids.include?(\"#{d1.oe_id}\") ? true : false, :name => \"oe_ids[]\"
          %label
            = \"#{d1.name}\""
      @children_1 = children(d1)
      if @children_1.present?
        cat_html << "
          %ul"
      end
      @children_1.each do |d2|
        cat_html << "
            %li.hide.depth2
              = check_box_tag \"category_#{d2.oe_id}\", \"#{d2.oe_id}\", service[:categories].present? && oe_ids.include?(\"#{d2.oe_id}\") ? true : false, :name => \"oe_ids[]\"
              %label
                = \"#{d2.name}\""
        @children_2 = children(d2)
        if @children_2.present?
          cat_html << "
              %ul"
        end
        @children_2.each do |d3|
          cat_html << "
                %li.hide.depth3
                  = check_box_tag \"category_#{d3.oe_id}\", \"#{d3.oe_id}\", service[:categories].present? && oe_ids.include?(\"#{d3.oe_id}\") ? true : false, :name => \"oe_ids[]\"
                  %label
                    = \"#{d3.name}\""
        end
      end
    end
  end

  File.open("app/views/forms/_categories.html.haml","w") do |f|
    f.write(cat_html)
  end

end