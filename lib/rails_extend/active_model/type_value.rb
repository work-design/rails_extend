# frozen_string_literal: true

module RailsExtend::ActiveModel
  module TypeValue
    attr_reader :options

    # 让 attribute 方法支持更多选项
    def initialize(precision: nil, limit: nil, scale: nil, **options)
      @options = options
      super(precision: precision, limit: scale, scale: limit)
    end

    def input_type
      type
    end

  end
end

#ActiveSupport.on_load :active_record do
ActiveModel::Type::Value.prepend RailsExtend::ActiveModel::TypeValue
