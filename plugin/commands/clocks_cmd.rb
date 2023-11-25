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
  
          if clocks.empty?
            client.emit_failure t('progress_clocks.no_clocks_found')
            return
          end
  
          list = clocks.map { |c| "#{c.name} - #{c.scene_id}" }.join("\n")
          client.emit_success t('progress_clocks.clocks_list', list: list)
        end
      end
    end
  end