require "erb"
require "wcag_color_contrast"
require "a11y/color/matrix/cli"
require "a11y/color/matrix/version"

module A11y
  module Color
    module Matrix

      PAGE = ERB.new(<<ERB
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>title</title>
    <style>
      body {
      font-size: 24px;
      }

      table {
      border-collapse: collapse;
      }

      

      th, td {
      border: 2px solid black;
      }

      td {     
      padding: 1em;
      }          

      .swatchContainer {
      display: flex;
      }

      .swatchContainer > .swatch:first-child {
      margin-right: 10px;
      }
      
      .swatch {
      font-size: 200%;
      width: 2em;
      height: 2em;
      line-height: 2em;
      text-align: center;
      border-radius: 12px;
      }

      .mono {
        font-family: monospace;
      }

      .ratio {
        text-align: right;
      }
    </style>
  </head>
  <body>
    <table>
      <thead>
        <tr>
          <th colspan="2">Colors</th>
          <th>Swatches</th>
          <th>Ratio</th>
          <th>Criteria met</th>
        </tr>
      </thead>
      <tbody>
      <%= rows %>
      </tbody>
  </body>
</html>
ERB
                    )

      ROW = ERB.new(<<ERB
<tr>
  <td class="mono">#<%= fg %></td>
  <td class="mono">#<%= bg %></td>
  <td class="swatchCell">
    <div class="swatchContainer">
      <div class="swatch" style="color: #<%= fg %>; background-color: #<%= bg %>">Q</div>
      <div class="swatch" style="background-color: #<%= fg %>; color: #<%= bg %>">Q</div>
    </div>
  </td>
  <td class="ratio"><%= ratio %></td>
  <td><%= rating %></td>
</tr>
ERB
                   )

      def self.getRating(ratio)
        if ratio >= 7.0
          return "AAA"
        end

        if ratio >= 4.5
          return "AA"
        end

        if ratio >= 3.0
          return "AA, large/bold"
        end

        return "Fails all criteria"
      end
      
      def self.rate(fg, bg)
        ratio = WCAGColorContrast.ratio(fg.dup, bg.dup)
        [fg, bg, ratio, getRating(ratio)]
      end
    end
  end
end
