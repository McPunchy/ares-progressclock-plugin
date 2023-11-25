module AresMUSH
    module ProgressClocks
      class Clock < Ohm::Model
        attribute :name
        attribute :max_value
        attribute :current_value
        attribute :creator
        attribute :type
        attribute :scene_id, :type => DataType::Integer
        
        def display_for_client
          filled = 'X' * self.current_value
          unfilled = '-' * (self.max_value - self.current_value)
          "#{filled}#{unfilled}"
        end
  
        def display_for_web
          filled = self.current_value
          total = self.max_value
          "clock#{filled}#{total}.jpg"
        end
      end
    end
  end