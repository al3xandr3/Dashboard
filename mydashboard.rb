

# World Country Population https://spreadsheets.google.com/ccc?key=phNtm3LmDZENoqUmTikF9DA#gid=10
module MyData 
  def self.get
    {
      "Estonia"        => [1341, 1341, 1340, 1339, 1338, 1337, 1336, 1334, 1333, 1331, 1329],
      "United Kingdom" => [62036,62417,62798,63177,63556,63935,64313,64688,65062,65433,65802],
      "United States"  => [310384,313085,315791,318498,321197,323885,326560,329222,331868,334496,337102],
      "Portugal"       => [10676, 10690, 10699, 10705, 10705, 10702, 10694, 10681, 10665, 10646, 10623]
    }
  end  
end
 
require 'date'
require 'haml'
require File.dirname(__FILE__) + '/lib/dashboard.rb'

def generate

  mydata = MyData.get 
  
  opts = {
    :line_graph => Dashboard::Chart
      .plot(:name => "Country Population",
            :subtitle => "https://spreadsheets.google.com/ccc?key=phNtm3LmDZENoqUmTikF9DA#gid=10",
            :xlabel => "Year",
            :ylabel => "Population",
            :start_time => Date.new(2010).to_time.to_i * 1000,
            :series => [
                        {
                          "pointInterval" => 365.5 * 24 * 3600 * 1000,
                          "pointStart" => Date.new(2010).to_time.to_i * 1000,
                          "name"=> 'Portugal',
                          "data" => mydata["Portugal"]
                        },
                        {
                          "pointInterval" => 365.5 * 24 * 3600 * 1000,
                          "pointStart" => Date.new(2010).to_time.to_i * 1000,
                          "name"=> 'Portugal Trend',
                          "data" => mydata["Portugal"].regression_simple.fit
                        },
                        {
                          "pointInterval" => 365.5 * 24 * 3600 * 1000,
                          "pointStart" => Date.new(2010).to_time.to_i * 1000,
                          "name"=> 'Estonia',
                          "visible"=> false,
                          "data" => mydata["Estonia"]
                        },
                        {
                          "pointInterval" => 365.5 * 24 * 3600 * 1000,
                          "pointStart" => Date.new(2010).to_time.to_i * 1000,
                          "name"=> 'United Kingdom',
                          "visible"=> false,
                          "data" => mydata["United Kingdom"]
                        },
                        {
                          "pointInterval" => 365.5 * 24 * 3600 * 1000,
                          "pointStart" => Date.new(2010).to_time.to_i * 1000,
                          "name"=> 'United States',
                          "visible"=> false,
                          "data" => mydata["United States"]
                        }
                       ]),
    
    :pt_2020 =>  mydata["Portugal"].last,
    :pt_spark => Dashboard::Chart
      .spark(:name => "pt_spark", 
             :start_time => Date.new(2010).to_time.to_i * 1000,
             :interval => 365.5 * 24 * 3600 * 1000,
             :ymin => mydata["Portugal"].min,
             :values => mydata["Portugal"]),
    
    :ee_2020 =>  mydata["Estonia"].last,
    :ee_spark => Dashboard::Chart
      .spark(:name => "ee_spark",
             :interval => 365.5 * 24 * 3600 * 1000,
             :start_time => Date.new(2010).to_time.to_i * 1000, 
             :ymin => mydata["Estonia"].min,
             :values => mydata["Estonia"]),

    :countries => (2010..2020).zip(mydata["Portugal"]).each {|y,c| [y.to_s,c] }
  }
  
  Haml::Engine
    .new(File.read(File.dirname(__FILE__) + "/mydashboard.haml"))
    .render(Object.new, opts)
end

if __FILE__ == $0
  # write file
  File.open("mydashboard.html", "w+").write generate 
  system("open mydashboard.html")  
end
