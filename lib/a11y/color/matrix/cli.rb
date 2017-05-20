module A11y
  module Color
    module Matrix
      class CLI < Thor
        option :w, :type => :boolean, :desc => "add white to comparisons"
        option :b, :type => :boolean, :desc => "add black to comparision"
        option :html, :type => :boolean, :desc => "generate HTML output"
        desc "check", "check list of colors"
        def check(*c)
          colors = Set.new add_white(add_black(c, options['b']), options['w'])
          #ratios = colors.sort.combination(2).map{|fg, bg|
          #  [fg, bg, WCAGColorContrast.ratio(fg.dup, bg.dup)] if fg != bg
          #}.sort{|x, y| x[2] <=> y[2]}.reverse

          ratios = colors.sort.combination(2).map{|fg, bg|
            Matrix::rate(fg, bg) if fg != bg
          }.sort{|x, y| x[2] <=> y[2]}.reverse
          
          if options['html']
            puts genHtml(ratios)
          else
            ratios.each do |fg, bg, ratio|
              puts "% 6s/% 6s: %5.2f %s" % [fg, bg, ratio, Matrix::getRating(ratio)]
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

          def genHtml(ratios)
            rows = ratios.map do |fg, bg, ratio, rating|
              b = binding
              b.local_variable_set(:fg, fg)
              b.local_variable_set(:bg, bg)
              b.local_variable_set(:ratio, "%5.2f" % [ratio])
              b.local_variable_set(:rating, rating)
              if bg == "ffffff"
                b.local_variable_set(:outline, "; border: 1px dashed black")
              else
                b.local_variable_set(:outline, "")
              end
              ROW.result(b)
            end

            b = binding
            b.local_variable_set(:rows, rows.join)
            PAGE.result(b)
          end
        end
      end
    end
  end
end
