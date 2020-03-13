module EventsHelper

  def date_for_display(date)

    begin
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.localtime.to_s), :format => :evento)
    rescue
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.to_s), :format => :evento)
    end


  end

  def date_in_time_zone(date)


    begin
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.in_time_zone.to_s), :format => :evento)
    rescue
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.to_s), :format => :evento)
    end


  end


  def get_day(date)

    begin
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.localtime.to_s), :format => '%d')
    rescue
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.to_s), :format => '%d')
    end

  end


 def get_month(date)

    begin
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.localtime.to_s), :format => '%b')
    rescue
      fsdate = (date == nil)? date :  I18n.l( DateTime.parse(date.to_s), :format => '%b')
    end

  end



end
