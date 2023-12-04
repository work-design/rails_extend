# frozen_string_literal: true

module RailsExtend::ActiveModel
  module Boolean
    EXTEND_FALSE_VALUES = [
      'n', :n,
      'N', :N,
      'no', :no,
      'No', :No,
      'NO', :NO
    ].to_set.freeze

    private
    def cast_value(value)
      if value == ''
        nil
      else
        !(ActiveModel::Type::Boolean::FALSE_VALUES + EXTEND_FALSE_VALUES).include?(value)
      end
    end

  end
end

ActiveModel::Type::Boolean.prepend RailsExtend::ActiveModel::Boolean
