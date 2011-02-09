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
      forecast = GoogleWeather.forecast_lat_long(37.775,-122.4183333)
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
  end