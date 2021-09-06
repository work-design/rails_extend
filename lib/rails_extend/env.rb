# frozen_string_literal: true

module RailsExtend::Env
  extend self

  def environments
    Dir.children(Rails.root.join('config', 'environments')).map! { |rb| rb.delete_suffix!('.rb') }
  end

end
