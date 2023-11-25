module AresMUSH
  module ProgressClocks
    class DeleteClockCmd
      include CommandHandler

      attr_accessor :clock_uid

      def parse_args
        self.clock_uid = cmd.args.to_i
      end

      def handle
        clock = Clock.find_one_by_clock_uid(self.clock_uid)
        if clock.nil?
          client.emit_failure("No clock found with this UID.")
        elsif clock.creator_id != enactor.name && !enactor.has_permission?("control_npcs")
          client.emit_failure("You are not the owner of this clock.")
        else
          clock.delete
          client.emit_success("Clock deleted.")
        end
      end
    end
  end
end