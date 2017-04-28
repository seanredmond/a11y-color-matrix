module A11y
  module Color
    module Matrix

      class CLI < Thor
        desc "check", "check list of colors"
        def check(*c)
          colors = Set.new c
          colors.sort.each do |bg|
            colors.sort.each do |fg|
              ratio = WCAGColorContrast.ratio(fg.dup, bg.dup) 
              if fg != bg
                puts "#{fg}/#{bg}: #{ratio}"
                puts 
              end
            end
          end
        end
      end
    end
  end
end
