module AresMUSH
  module ProgressClocks
    class DeleteClockCmd
    include CommandHandler

    attr_accessor :name

    def parse_args
      args = cmd.args.match(/"([^"]+)"\s*(\d*)/)
      self.name = args[1]
      self.scene_id = args[2].empty? ? nil : args[2].to_i
    end

    def handle
      if self.scene_id
        clock = Clock.find_one_by_name_and_scene_id(self.name, self.scene_id)
      else
        clock = Clock.find_one_by_name_and_creator(self.name, enactor)
      end

      if !clock && enactor.has_permission?("control_npcs")
        clocks = Clock.find_by_name(self.name)
        if clocks.size > 1
          list = clocks.map { |c| "#{c.name} - #{c.creator.name} - #{c.scene_id}" }.join("\n")
          client.emit_failure t('progress_clocks.multiple_clocks_found', list: list)
          return
        else
          clock = clocks.first
        end
      end

      if !clock
        client.emit_failure t('progress_clocks.clock_not_found', name: self.name)
        return
      end

      if enactor != clock.creator && !enactor.has_permission?("control_npcs")
        client.emit_failure t('dispatcher.not_allowed')
        return
      end

      clock.delete
      client.emit_success t('progress_clocks.clock_deleted', name: self.name)
    end
  end
end