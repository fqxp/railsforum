module ApplicationHelper
  def human_time(dt)
    if dt.nil?
      return ''
    end
    
    local_dt = dt.in_time_zone(Rails.application.config.default_time_zone)
    local_now = Time.now.in_time_zone(Rails.application.config.default_time_zone)
    
    if local_now - local_dt < 10.minutes
      minutes = ((local_now-local_dt) / 60).round
      return I18n.t('.date.extra.minutes_ago', :count => minutes)
    elsif local_dt > local_now.beginning_of_day
      return "#{I18n.t('.date.extra.today')}, #{I18n.l(local_dt, :format => :time)}"
    elsif local_dt > (local_now - 1.day).beginning_of_day
      return "#{I18n.t('.date.extra.yesterday')}, #{I18n.l(local_dt, :format => :time)}"
    elsif local_dt > local_now.beginning_of_year
      return I18n.l(local_dt, :format => :date_without_year)
    else
      return I18n.l(local_dt, :format => :date)
    end
  end
end
