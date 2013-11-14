module ApplicationHelper

  def create_hours(params={})
    start_time = params[:start_time] ? params[:start_time] : 6.hours
    end_time = params[:end_time] ? params[:end_time] : 23.hours
    increment = params[:increment] ? params[:increment] : 5.minutes
    Array.new(1 + (end_time - start_time)/increment) do |i|
      (Time.now.midnight + (i*increment) + start_time).strftime("%H:%M")
    end
  end

  def days
    %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]
  end

  def accessibility_options
    [
      ["Information on CD", "cd"],
      ["Interpreter for the deaf", "deaf_interpreter"],
      ["Disabled Parking", "disabled_parking"],
      ["Elevator", "elevator"],
      ["Ramp", "ramp"],
      ["Disabled Restroom", "restroom"],
      ["Information on tape or in Braille", "tape_braille"],
      ["TTY", "tty"],
      ["Wheelchair", "wheelchair"],
      ["Wheelchair-accessible van", "wheelchair_van"]
    ]
  end

  # Handles formatting of the page title by appending site name to end
  # of a particular page's title.
  # @param page_title [String] the page title from a particular view.
  def title(page_title)
    default = "SMC-Connect Admin"
    if page_title.present?
      content_for :title, "#{page_title.to_s} | #{default}"
    else
      content_for :title, default
    end
  end
end
