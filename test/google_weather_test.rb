require "test/unit"
require "google_weather"


class TC_MyTest < Test::Unit::TestCase

    def test_denver
      forecast = GoogleWeather.forecast("Denver,CO")
      assert(!forecast[:current].nil?,"Current conditions were nil.")
      assert( forecast[:current][:conditions])
      assert( forecast[:current][:temp_f])
      assert( forecast[:current][:temp_c])
      assert( forecast[:current][:humidity])
      assert( forecast[:current][:wind])
      
      assert(!forecast[:future].nil?, "Future forecasts were nil.")
      assert(forecast[:future]["Mon"] || forecast[:future]["Tue"] || forecast[:future]["Wed"] ||
             forecast[:future]["Thu"] || forecast[:future]["Fri"] || forecast[:future]["Sat"] ||
             forecast[:future]["Sun"])
      
      assert(!forecast[:location].nil?, "Forecast location data was nil.")
      
      assert(forecast[:location][:city] == "Denver, CO")
      assert(forecast[:location][:postal_code] == "Denver,CO")
    end
    
    def test_sf
      forecast = GoogleWeather.forecast("94115")
      assert(!forecast[:current].nil?,"Current conditions were nil.")
      assert( forecast[:current][:conditions])
      assert( forecast[:current][:temp_f])
      assert( forecast[:current][:temp_c])
      assert( forecast[:current][:humidity])
      assert( forecast[:current][:wind])
      
      assert(!forecast[:future].nil?, "Future forecasts were nil.")
      assert(forecast[:future]["Mon"] || forecast[:future]["Tue"] || forecast[:future]["Wed"] ||
             forecast[:future]["Thu"] || forecast[:future]["Fri"] || forecast[:future]["Sat"] ||
             forecast[:future]["Sun"])
      
      assert(!forecast[:location].nil?, "Forecast location data was nil.")
      
      assert(forecast[:location][:city] == "San Francisco, CA")
      assert(forecast[:location][:postal_code] == "94115")
    end
    
    def test_lat_long
      forecast = GoogleWeather.forecast(:lat => 37.775,:long => -122.4183333)
      forecast_sf = GoogleWeather.forecast("San Francisco, CA")
      
      assert( forecast[:current][:conditions] == forecast_sf[:current][:conditions])
      
      assert( forecast[:location][:latitude] == "37775000")
      assert( forecast[:location][:longitude] == "-122418333")
    end
    
    def test_utf_town
      forecast = GoogleWeather.forecast('Albarracin, ES')
      
      assert(!forecast[:current].nil?,"Current conditions were nil.")
      assert( forecast[:current][:conditions])
      assert( forecast[:current][:temp_f])
      assert( forecast[:current][:temp_c])
      assert( forecast[:current][:humidity])
      assert( forecast[:current][:wind])
      
      assert(!forecast[:future].nil?, "Future forecasts were nil.")
      assert(forecast[:future]["Mon"] || forecast[:future]["Tue"] || forecast[:future]["Wed"] ||
             forecast[:future]["Thu"] || forecast[:future]["Fri"] || forecast[:future]["Sat"] ||
             forecast[:future]["Sun"])
      
      assert(!forecast[:location].nil?, "Forecast location data was nil.")
    end
    
    def test_funky_southafrica
      forecast = GoogleWeather.forecast(:lat => -32.162862, :long => 19.03008)
      
      assert(!forecast[:current].nil?,"Current conditions were nil.")
      assert( forecast[:current][:conditions])
      assert( forecast[:current][:temp_f])
      assert( forecast[:current][:temp_c])
      assert( forecast[:current][:humidity])
      assert( forecast[:current][:wind])
      
      assert(!forecast[:future].nil?, "Future forecasts were nil.")
      assert(forecast[:future]["Mon"] || forecast[:future]["Tue"] || forecast[:future]["Wed"] ||
             forecast[:future]["Thu"] || forecast[:future]["Fri"] || forecast[:future]["Sat"] ||
             forecast[:future]["Sun"])
      
      assert(!forecast[:location].nil?, "Forecast location data was nil.")
    end
    
    def test_funky_nz
      forecast = GoogleWeather.forecast(:lat => -43.1833, :long => 171.725998)
      
      assert(!forecast[:current].nil?,"Current conditions were nil.")
      assert( forecast[:current][:conditions])
      assert( forecast[:current][:temp_f])
      assert( forecast[:current][:temp_c])
      assert( forecast[:current][:humidity])
      assert( forecast[:current][:wind])
      
      assert(!forecast[:future].nil?, "Future forecasts were nil.")
      assert(forecast[:future]["Mon"] || forecast[:future]["Tue"] || forecast[:future]["Wed"] ||
             forecast[:future]["Thu"] || forecast[:future]["Fri"] || forecast[:future]["Sat"] ||
             forecast[:future]["Sun"])
      
      assert(!forecast[:location].nil?, "Forecast location data was nil.")
    end
    
    def test_elchorro_noforecast
      begin
        forecast = GoogleWeather.forecast(:lat => -49.3335, :long => -72.937103)
        assert_false(true,"Should have raised a noforecastexception.")
      rescue GoogleWeather::NoForecastException => e
        #Good
        assert(true)
      end
        
    end
    
    #use this test to try doing forecasts around the globe.
    #Commenting out for now because if you use it you will begin receiving 503 requests from google
    #Quite quickly.
#    def test_aroundtheworld
#      lat_inc = 0.5
#      long_inc = 0.5
#      
#      long = -179.5
#      while long < 180
#        lat = -89.5
#        
#        while lat <= 90
#          begin
#            forecast = GoogleWeather.forecast(:lat => lat, :long => long)
#          rescue GoogleWeather::NoForecastException => e
#            puts "No forecast for lat: #{lat} long: #{long} because : #{e.to_s}"
#          end
#          
#          lat += lat_inc
#        end
#        long += long_inc
#      end
#      
#    end
  end