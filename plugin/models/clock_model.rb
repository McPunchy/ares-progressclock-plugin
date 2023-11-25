module AresMUSH
  module ProgressClocks
    class Clock < Ohm::Model
      attribute :name
      attribute :max_value
      attribute :current_value
      attribute :creator_id
      attribute :type
      attribute :scene_id

      index :name
      index :creator_id
      index :type
      index :scene_id

      def self.find_one_by_creator_type_and_scene_id(creator_id, type, scene_id)  
        find(creator_id: creator_id, type: type, scene_id: scene_id).first
      end

      def self.owned_by(character)
        find(creator_id: character.name)  
      end

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