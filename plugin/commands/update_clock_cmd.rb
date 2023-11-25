module AresMUSH
  module ProgressClocks
    class UpdateClockCmd
      include CommandHandler

      attr_accessor :clock_uid, :current_value, :private

      def parse_args
        args = cmd.args.match(/(\d+)\s+(\d+)/)
        self.clock_uid = args[1].to_i
        self.current_value = args[2].to_i
        self.private = cmd.switch_is?("private")
      end

      def handle
        clock = Clock.find_one_by_clock_uid(self.clock_uid)

        
        if !clock
          client.emit_failure t('progress_clocks.clock_not_found', uid: self.clock_uid)
          return
        end

        if enactor.name != clock.creator_id && !enactor.has_permission?("control_npcs")
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        Global.logger.info "max_value before conversion: #{clock.max_value}"
        if self.current_value > clock.max_value.to_i
          client.emit_failure t('progress_clocks.current_value_exceeds_max')
          return
        end

        Global.logger.info "current_value type: #{self.current_value.class}, max_value type: #{clock.max_value.class}"

        clock.update(current_value: self.current_value)
        display = clock.display_for_client
        message = t('progress_clocks.clock_updated', name: clock.name, display: display)

        ProgressClocks.emit_clockmessage(message, client, enactor_room, self.private)
        Global.logger.info t('progress_clocks.clock_updated_log', name: clock.name, creator: enactor_name)
      end
    end
  end
end