module A11y
  module Color
    module Matrix
      class CLI < Thor
        option :w, :type => :boolean, :desc => "add white to comparisons"
        option :b, :type => :boolean, :desc => "add black to comparision"
        desc "check", "check list of colors"
        def check(*c)
          colors = Set.new add_white(add_black(c, options['b']), options['w'])
          colors.sort.combination(2).each do |fg, bg|
            ratio = WCAGColorContrast.ratio(fg.dup, bg.dup) 
            if fg != bg
              puts "% 6s/% 6s: %5.2f" % [fg, bg, ratio]
            end
          end
        end

        no_commands do
          def add_black(c, b)
            if b
              return c + ['000000']
            end
            
            return c
          end
          
          def add_white(c, w)
            if w
              return c + ['ffffff']
            end

            return c
          end
        end
      end
    end
  end
end
