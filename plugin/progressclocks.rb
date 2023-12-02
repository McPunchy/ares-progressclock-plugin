$:.unshift File.dirname(__FILE__)

module AresMUSH
    module ProgressClocks
      def self.plugin_dir
        File.dirname(__FILE__)
      end
  
      def self.shortcuts
        Global.read_config("progress_clocks", "shortcuts")
      end

      def self.version
        "0.1a"
      end
  
      def self.get_cmd_handler(client, cmd, enactor)
        case cmd.root
        when "clock"
          case cmd.switch
          when "create"
            return CreateClockCmd
          when "update"
            return UpdateClockCmd
          when "delete"
            return DeleteClockCmd
          when "list"
            return ClocksCommand
          end
        end
        return nil
      end
  
      def self.get_event_handler(event_name)
        case event_name
        when "ClockCreatedEvent"
          return ClockCreatedEventHandler
        when "ClockUpdatedEvent"
          return ClockUpdatedEventHandler
        when "ClockDeletedEvent"
          return ClockDeletedEventHandler
        when "ClocksListedEvent"
          return ClockListedEventHandler
        end
        return nil
      end
  
      def self.get_web_request_handler(request)
        case request.cmd
        when "getClocks"
          return GetClockRequestHandler
        when "createClock"
          return CreateClockRequestHandler
        when "updateClock"
          return UpdateClockRequestHandler
        when "deleteClock"
          return DeleteClockRequestHandler
        when "getClocksList"
          return GetClockListRequestHandler
        end
        return nil
      end

      def self.emit_clockmessage(message, client, enactor_room, private)
        if (private)
          client.emit_success message
        else
          enactor_room.emit message
          if (enactor_room.scene)
            if !Scenes.can_pose_char?(enactor, char)
              client.emit_success message
              return { error: "#{t('dispatcher.not_allowed')} The clock was updated, but there was an error sending to scene." }
            end
            Scenes.add_to_scene(enactor_room.scene, message)
          end
        end
      end

    end
  end
