# frozen_string_literal: true

module RailsExtend::Routes
  extend self

  def find_actions(controller_path)
    r = controllers[controller_path]
    if r.is_a?(Hash)
      r.keys
    else
      []
    end
  end

  def verbs(controller, action)
    routes_wrapper.select { |i| i[:controller] == controller.to_s && i[:action] == action.to_s }.map { |i| i[:verb] }.uniq
  end

  def actions(cached = true)
    return @actions if cached && defined? @actions

    @actions = businesses(cached).transform_values do |businesses|
      businesses.group_by(&->(i){ i[:namespace] }).transform_values! do |namespaces|
        namespaces.group_by(&->(i){ i[:controller] }).transform_values! do |controllers|
          controllers.each_with_object({}) { |i, h| h.merge! i[:action] => i }
        end
      end
    end
  end

  def controllers(cached = true)
    return @controllers if cached && defined? @controllers

    @controllers = _controllers(cached).transform_values do |value|
      value.each_with_object({}) { |i, h| h.merge! i[:action] => i }
    end
  end

  def controller_paths(cached = true)
    return @controller_paths if cached && defined? @controller_paths

    @controller_paths = _controllers(cached).transform_values do |controllers|
      controllers[0].slice(:business, :namespace)
    end
  end

  def _controllers(cached = true)
    return @_controllers if cached && defined? @_controllers
    @_controllers = routes_wrapper(cached).group_by(&->(i){ i[:controller] })
  end

  def businesses(cached = true)
    return @businesses if cached && defined? @businesses
    @businesses = routes_wrapper(cached).group_by(&->(i){ i[:business] })
  end

  def namespaces(cached = true)
    return @namespaces if cached && defined? @namespaces
    @namespaces = routes_wrapper(cached).group_by(&->(i){ i[:namespace] })
  end

  def routes_wrapper(cached = true)
    return @routes_wrapper if cached && defined?(@routes_wrapper)

    @routes_wrapper = Rails.application.routes.routes.map do |route|
      next if (route.defaults[:controller].blank? || route.defaults[:action].blank?)
      detail(route)
    end.compact
  end

  def blank_routes_wrapper(cached = true)
    return @blank_routes_wrapper if cached && defined?(@blank_routes_wrapper)

    @blank_routes_wrapper = Rails.application.routes.routes.map do |route|
      next unless (route.defaults[:controller].blank? || route.defaults[:action].blank?)
      detail(route)
    end.compact
  end

  private
  def detail(route)
    {
      verb: route.verb,
      path: route.path.spec.to_s,
      namespace: route.defaults[:namespace].to_s,
      business: route.defaults[:business].to_s,
      controller: route.defaults[:controller],
      action: route.defaults[:action],
      required_parts: route.required_parts
    }
  end

end
