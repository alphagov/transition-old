module Transition
  module Controllers
    module ReadOnlyFilter
      extend ActiveSupport::Concern

      included do
        before_filter :require_action_enabled!
        rescue_from Transition::FeatureUnavailableError, with: :error_501
      end

      def error_501(unavailable_error)
        render status: 501, text: unavailable_error.to_s
      end

      def require_action_enabled!
        return unless DISABLE_EDITING

        enabled_actions = ['show', 'index', 'hits_download']
        unless enabled_actions.include?(params[:action])
          raise Transition::FeatureUnavailableError.new(params[:controller], params[:action])
        end
      end
    end
  end
end

