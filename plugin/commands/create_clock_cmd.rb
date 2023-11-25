module AresMUSH
  module ProgressClocks
    class CreateClockCmd
      include CommandHandler

      attr_accessor :name, :max_value, :current_value, :scene_id, :type, :private, :creator_id

      def parse_args
        args = cmd.args.match(/(\w+)?\s+"([^"]+)"\s+(\d+)(?:\s+(\d+))?/)
        
        if args
          self.type = args[1] || 'NoType'
          self.name = args[2]
          self.current_value = args[4] ? args[3].to_i : 0
          self.max_value = args[4] ? args[4].to_i : args[3].to_i
          self.private = cmd.switch_is?("private")
        
          if self.max_value < self.current_value
            self.max_value, self.current_value = self.current_value, self.max_value
          end
        else
          client.emit_failure "Invalid arguments. Expected format: [type] \"name\" current_value [max_value]"
        end
      end

      def handle
        config = Global.read_config("progress_clocks")
        
        if !config["size_#{self.max_value}"]
          allowed_sizes = config.keys.select { |k| k.start_with?('size_') }.map { |k| k[5..] }
          client.emit_failure t('progress_clocks.invalid_clock_size', allowed_sizes: allowed_sizes.join(", "))
          return
        end

        existing_clock = Clock.find_one_by_creator_type_and_scene_id(enactor.name, self.type, self.scene_id)
        if existing_clock
          client.emit_failure t('progress_clocks.clock_already_exists', name: existing_clock.name)
          return
        end
        
        if self.type.downcase == 'scene' && self.scene_id.nil? && enactor_room.scene
          self.scene_id = enactor_room.scene.id
        end
        

        clock = Clock.create(name: self.name, max_value: self.max_value, current_value: self.current_value, creator_id: enactor.name, scene_id: self.scene_id, type: self.type)
        Global.logger.debug "Created clock: #{clock.inspect}"
        Global.logger.debug "Creator: #{clock.creator_id}"
        display = clock.display_for_client
        message = t('progress_clocks.clock_created', creator: enactor_name, name: clock.name, display: display)
        
        ProgressClocks.emit_clockmessage(message, client, enactor_room, self.private)
        Global.logger.info t('progress_clocks.clock_created_log', name: clock.name, creator: enactor_name)
      end

    end
  end
end