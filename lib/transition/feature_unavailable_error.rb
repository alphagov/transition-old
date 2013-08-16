module Transition
  class FeatureUnavailableError < RuntimeError
    attr_accessor :controller, :action
    def initialize(controller, action)
      self.controller, self.action = controller, action
    end

    def to_s
      "Feature at #{controller}##{action} unavailable, currently read-only"
    end
  end
end
