
require File.dirname(__FILE__) + "/statistics.rb"

module Dashboard
  require 'erb'
  require 'json'

  module Chart
    extend self

    def bar arg={}
      
      arg[:height] = arg[:height] || ""
      arg[:width] = arg[:width] || ""

      hor_bar = %{
      <div id="<%= arg[:name] %>" 
        style="height:<%= arg[:height] %>px;width:<%= arg[:width] %>px;"></div>
      <script type="text/javascript">
      var chart;
      $(document).ready(function() {
       chart = new Highcharts.Chart({
        chart: {
            renderTo: '<%= arg[:name] %>',
            defaultSeriesType: 'bar',
            margin: [30, 70, 30, 130]
        },
        title: {
          text: '<%= arg[:name] %>',
          y: 5
        },
        credits:{
            enabled:false
        },
        legend: {
            enabled:false
        },
        tooltip: {
          formatter: function() {
            return '<b>'+ this.y +'</b>';
          }
        },
        xAxis: {
            categories: <%= arg[:categories] %>,
            labels:{
                align:'right'
            }
        },
        yAxis: {
          labels: {
            enabled:true
          },
          title: {
            text: ''
          },
        },
        series: <%= arg[:series].to_json %>           
      });
      });
      </script>
      }
      ERB.new(hor_bar).result(binding)
    end

    def pie arg={}

      arg[:height] = arg[:height] || "300"
      arg[:width] = arg[:width] || "300"

      pie_chart = %{
      <div id="<%= arg[:name] %>" 
        style="height:<%= arg[:height] %>px;width:<%= arg[:width] %>px;"></div>
      <script type="text/javascript">
      var chart;
      $(document).ready(function() {
         chart = new Highcharts.Chart({
            chart: {
               renderTo: '<%= arg[:name] %>',
               plotBackgroundColor: null,
               plotBorderWidth: null,
               plotShadow: false
            },
            title: {
               text: '<%= arg[:name] %>'
            },
            tooltip: {
               formatter: function() {
                  return '<b>'+ this.point.name +'</b>: '+ this.y +' %';
               }
            },
            plotOptions: {
             pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                dataLabels: {
                   enabled: false
                },
                showInLegend: true
               }
             },
             credits:{
              enabled:false
            },
            series: [{
               type: 'pie',
               name: '<%= arg[:name] %>',
               data: <%= arg[:values] %>
            }]
         });
      });
      </script>
      }
      ERB.new(pie_chart).result(binding)
    end

    def spark arg={} 
      
      arg[:height] = arg[:height] || "25"
      arg[:width] = arg[:width] || "130"

      spark_chart = %{
      <div id="<%= arg[:name] %>" 
        style="height:<%= arg[:height] %>px;width:<%= arg[:width] %>px;"></div>
      <script type="text/javascript">
        var month = new Array("Jan","Feb","Mar","Apr","May","Jun",
                              "Jul","Aug","Sept","Oct","Nov","Dec");
       
        var chart = new Highcharts.Chart({
        chart: {
            renderTo: '<%= arg[:name] %>',
            defaultSeriesType: 'area',
            margin:[0,0,0,0],
            //borderWidth:1
        },
        title:{
            text:''
        },
        credits:{
            enabled:false
        },
        xAxis: {
            labels: {
                enabled:false
            }
        },
        yAxis: {
            <% unless arg[:ymin].nil? %>
            min: <%= arg[:ymin] %>,
            <% end %>
            maxPadding:0,
            minPadding:0,
            endOnTick:false,
            labels: {
                enabled:false
            }
        },
        legend: {
            enabled:false
        },
        tooltip: {
             borderWidth: 1,
             formatter: function() {
               return (new Date(this.x)).getDate() + ' ' +   
                      month[(new Date(this.x)).getMonth()] + ' ' +
                      (new Date(this.x)).getFullYear() + 
                       ': '+ this.y;
             }
          },
        plotOptions: {
            series:{
                lineWidth:1,
                shadow:false,
                states:{
                    hover:{
                        lineWidth:1
                    }
                },
                marker:{
                    //enabled:false,
                    radius:1,
                    states:{
                        hover:{
                            radius:2
                        }
                    }
                }
            }
        },
        series: [{
            color:'#666',
            fillColor:'rgba(204,204,204,.25)',
            pointInterval: <%= arg[:interval] || 24 * 3600 * 1000 %>,
            pointStart: <%= arg[:start_time] %>,
            data: <%= arg[:values] %>        
        }]
      });
      </script>
      }
      ERB.new(spark_chart).result(binding)
    end

    def plot arg={}
      
      arg[:height] = arg[:height] || ""
      arg[:width] = arg[:width] || ""

      line_series = %{
      <div id="<%= arg[:name] %>" 
        style="height:<%= arg[:height] %>px;width:<%= arg[:width] %>px;"></div>
      <script type="text/javascript">
       var month = new Array("Jan","Feb","Mar","Apr","May","Jun",
                             "Jul","Aug","Sept","Oct","Nov","Dec");
       var chart;
       $(document).ready(function() {
       chart = new Highcharts.Chart({
          chart: {
             renderTo: '<%= arg[:name] %>',
             defaultSeriesType: 'line',
             marginRight: 40,
             marginBottom: 95
          },
          credits:{
            enabled:false
          },
          plotOptions: {
             line: {
                dataLabels: {                  
                   enabled: <%= arg[:data_labels] || false %>
                }
             }
          },
          title: {
             text: '<%= arg[:name] %>',
             x: -20 //center
          },
          subtitle: {
             text: '<%= arg[:subtitle] %>',
             x: -20
          },
          xAxis: {
             type: "datetime",
             title: {
                text: '<%= arg[:xlabel] %>'
             },
          },
          yAxis: {
             <% unless arg[:ymin].nil? %>
             min: <%= arg[:ymin] %>,
             <% end %>
             title: {
                text: '<%= arg[:ylabel] %>'
             },
          },
          tooltip: {
            formatter: function() {
               return (new Date(this.x)).getDate() + ' ' +   
                      month[(new Date(this.x)).getMonth()] + ' ' +
                      (new Date(this.x)).getFullYear() + 
                       ': '+ this.y;
             }
          },

          series: <%= arg[:series].to_json %>        
         });
        });
      </script>
      }
      ERB.new(line_series).result(binding)
    end
    
    def html chart
      require 'haml'
      opts = {chart: chart}

      html = %{
!!!
%html
  %head
    %title Chart
    %script{:type => "text/javascript", :charset => "utf-8", 
    :src => "https://ajax.googleapis.com/ajax/libs/jquery/1.6.0/jquery.min.js"}
    %script{:type => "text/javascript", :charset => "utf-8", 
            :src => "http://www.highcharts.com/js/highcharts.js"}
  %body
    = chart
      }
      
      o = Haml::Engine.new(html).render(Object.new, opts)
      File.open(File.dirname(__FILE__) + "/chart.html", "w+").write(o)
      system("open " + File.dirname(__FILE__) + "/chart.html")  
    end

  end
end


#Add to Array 
class Array
  def plot arg={}
    arg[:x] = (0...self.size).to_a unless arg[:x] # create x unless given
    c = Dashboard::Chart
      .plot(
            name: "scatter",
            legend_enabled: "false",
            series: [{
                       name: "scatter",
                       data: arg[:x].zip(self)
                     }]
            )
    Dashboard::Chart.html(c)
  end


  def hist arg={}
    hist = self.frequency    
    cat  = hist.keys.sort.collect { |x| x.to_s  }
    vals = hist.keys.sort.collect { |x| hist[x] }
    c = Dashboard::Chart
      .bar(
                   name: "bar",
                   categories: cat,
                   series: [{
                              name: "bar",
                              data: vals
                            }]
                   )
    Dashboard::Chart.html(c)
  end

end


if __FILE__ == $0
  
  # a = Dashboard::Chart.spark(:name => "Sparker", 
  #                          :start_time => Time.now.to_i * 1000, 
  #                          :values => [70, 75, 11, 100])
  
  # b = Dashboard::Chart.pie(:name => "Sources (30 days)", 
  #                        :values => [70, 75, 73])
  
  # c = Dashboard::Chart.bar(:name => "Source (30 days)", 
  #                        :categories => ["a", "b", "c"],
  #                        :values => [70, 75, 73])

  # Dashboard::Chart.html(a + b + c)

# [1, 2, 2, 2, 3, 4, 5, 6, 5, 5, 5, 7, 8, 8, 8, 8, 8, 8, 8].plot
  [1, 2, 2, 2, 3, 4, 5, 6, 5, 5, 5, 7, 8, 8, 8, 8, 8, 8, 8].hist
end
