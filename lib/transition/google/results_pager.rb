module Transition
  module Google
    class ResultsPager
      include Enumerable

      attr_accessor :parameters, :client

      def initialize(parameters, client = APIClient.analytics_client!)
        self.parameters = parameters
        self.client     = client

        @analytics = client.discovered_api('analytics', 'v3')
      end

      def do_each(start_index = 1, &block)
        parameters.merge!('start-index' => start_index) unless start_index == 1
        result = client.execute(api_method: @analytics.data.ga.get, parameters: parameters)

        JSON.parse(result.body).tap do |json|
          json['rows'].each { |row| yield row }
          if (next_link = json['nextLink'])
            next_index = next_link.match(/&start-index=([0-9]*)/)[1]
            do_each(next_index, &block) if next_index
          end
        end
      end

      def each
        do_each(1) { |row| yield row }
      end
    end
  end
end