module AresMUSH
    module ProgressClocks
      class ClocksCommand
        include CommandHandler
  
        attr_accessor :target_name
  
        def parse_args
          self.target_name = cmd.args ? trim_arg(cmd.args) : nil
        end
  
        def check_can_view
          return nil if self.target_name.nil? || enactor.has_permission?("control_npcs")
          return t('dispatcher.not_allowed')
        end
  
        def handle
          target = Character.named(self.target_name) || enactor
          clocks = Clock.owned_by(target)

          # Debugging information:
          Global.logger.debug "Target: #{target}"
          Global.logger.debug "Clocks: #{clocks.to_a}"
  
          if clocks.empty?
            client.emit_failure t('progress_clocks.no_clocks_found')
            return
          end
  
          list = clocks.map do |c| 
            if c.type.downcase == 'scene'
              "#{c.clock_uid}: #{c.name} (#{c.type}) - Scene ID: #{c.scene_id} - Progress: #{c.current_value}/#{c.max_value}"
            else
              "#{c.clock_uid}: #{c.name} (#{c.type}) - Progress: #{c.current_value}/#{c.max_value}"
            end
          end.join("\n")
          client.emit_success t('progress_clocks.clocks_list', list: list)
        end
      end
    end
  end