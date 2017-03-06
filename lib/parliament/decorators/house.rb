module Parliament
  module Decorators
    module House

      def name
        respond_to?(:houseName) ? houseName : ''
      end

      def commons
        house_of_lords_id
      end

      def lords
        house_of_lords_id
      end

      def seat_incumbencies
        return @seat_incumbencies unless @seat_incumbencies.nil?

        seat_incumbencies = []
        seats.each do |seat|
          seat_incumbencies << seat.seat_incumbencies
        end

        @seat_incumbencies = seat_incumbencies.flatten.uniq
      end

      def seats
        respond_to?(:houseHasHouseSeat) ? houseHasHouseSeat : []
      end

      def house_incumbencies
        respond_to?(:houseHasHouseIncumbency) ? houseHasHouseIncumbency : []
      end

      private

      def house_of_lords_id
        respond_to?(:graph_id) ? graph_id : ''
      end
    end
  end
end
