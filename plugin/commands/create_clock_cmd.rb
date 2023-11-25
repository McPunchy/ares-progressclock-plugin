module AresMUSH
    module ProgressClocks
      class CreateClockCmd
        include CommandHandler
  
        attr_accessor :name, :max_value, :current_value
  
        def parse_args
            name_part, value_part = cmd.args.split("=")
            self.name = name_part.strip
            values = value_part.split("/")
            self.current_value = values[0].strip.to_i
            self.max_value = values[1].strip.to_i
          
            if self.max_value < self.current_value
              self.max_value, self.current_value = self.current_value, self.max_value
            end
          end
  
        def handle
            clock = Clock.create(name: self.name, max_value: self.max_value, current_value: self.current_value, creator: enactor)
            client.emit_success "Clock #{clock.name} created!"
        end
      end
    end
  end