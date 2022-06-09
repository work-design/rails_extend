class ActiveSupport::Duration

  def inspect
    return "#{value} #{I18n.t('duration.seconds')}" if @parts.empty?

    @parts.sort_by(&->(unit){ PARTS.index(unit[0]) }).map(&->(unit, val){ "#{val} #{val == 1 ? I18n.t('duration')[unit] : I18n.t('durations')[unit]}" }).to_sentence(locale: I18n.locale)
  end

  def in_all
    all = {}
    PARTS_IN_SECONDS.map do |i|

    end
  end

end
