class ActiveSupport::Duration

  def inspect
    return "#{value} #{I18n.t('duration.seconds')}" if @parts.empty?

    @parts.sort_by do |unit,  _|
      PARTS.index(unit)
    end.map do |unit, val|
      "#{val} #{val == 1 ? I18n.t('duration')[unit] : I18n.t('durations')[unit]}"
    end.to_sentence(locale: I18n.locale)
  end

  def in_all
    all = {}

    PARTS_IN_SECONDS.map do |key, value|
      all[key] = (in_seconds / value.to_f).round(2)
    end

    all
  end

end
