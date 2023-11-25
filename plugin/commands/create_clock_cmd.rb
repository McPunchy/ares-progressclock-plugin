module AresMUSH
  module ProgressClocks
    class CreateClockCmd
      include CommandHandler

      attr_accessor :name, :max_value, :current_value, :scene_id, :type, :private

      def parse_args
        args = cmd.args.match(/(\w+)?\s+"([^"]+)"\s+(\d+)\s+(\d+)/)
        self.type = args[1] || 'NoType'
        self.name = args[2]
        self.current_value = args[3].to_i
        self.max_value = args[4].to_i
        self.private = cmd.switch_is?("private")
      
        if self.max_value < self.current_value
          self.max_value, self.current_value = self.current_value, self.max_value
        end
      end

      def handle
        allowed_sizes = Global.read_config("progress_clocks", "allowed_sizes")
        
        if !allowed_sizes.include?(self.max_value)
          client.emit_failure t('progress_clocks.invalid_clock_size', allowed_sizes: allowed_sizes.join(", "))
          return
        end

        existing_clock = Clock.find_one_by_creator_type_and_scene_id(enactor, self.type, self.scene_id)
        if existing_clock
          client.emit_failure t('progress_clocks.clock_already_exists', name: existing_clock.name)
          return
        end

        clock = Clock.create(name: self.name, max_value: self.max_value, current_value: self.current_value, creator: enactor, scene_id: self.scene_id, type: self.type)
        display = clock.display_for_client
        message = t('progress_clocks.clock_created', creator: enactor_name, name: clock.name, display: display)
        
        ProgressClocks.emit_clockmessage(message, client, enactor_room, self.private)
        Global.logger.info t('progress_clocks.clock_created_log', name: clock.name, creator: enactor_name)
      end
      end
    end
  end
end