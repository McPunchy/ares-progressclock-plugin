module AresMUSH
  module ProgressClocks
    class Clock < Ohm::Model
      attribute :name
      attribute :max_value
      attribute :current_value
      attribute :creator_id
      attribute :type
      attribute :scene_id
      attribute :clock_uid

      index :name
      index :creator_id
      index :type
      index :scene_id
      index :clock_uid

      def self.max_uid
        all.map(&:clock_uid).max
      end

      def self.check_duplicate_clocks(name, creator_id, scene_id)
        find(name: name, creator_id: creator_id, scene_id: scene_id).first
      end

      def self.find_one_by_clock_uid(clock_uid)
        find(clock_uid: clock_uid).first
      end

      def self.owned_by(character)
        find(creator_id: character.name)  
      end

      def display_for_client
        filled = 'X' * self.current_value
        unfilled = '-' * (self.max_value.to_i - self.current_value)
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