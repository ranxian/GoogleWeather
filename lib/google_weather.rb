require 'net/http'
require 'open-uri'
require "nokogiri"

class GoogleWeather
  
  class GoogleWeather::NoForecastException < Exception
    
  end
  
  def GoogleWeather.forecast(area_or_options)
    if area_or_options.is_a?(Hash)
      lat = area_or_options[:lat] || area_or_options[:latitude]
      long = area_or_options[:long] || area_or_options[:longitude] || area_or_options[:lng]
      if lat.nil? || long.nil?
        raise ArgumentError, "To forecast via latitude and longitude, :lat & :long are required and must not be nil."
      end
      
      return forecast_lat_long(lat,long)
    
    elsif area_or_options.nil?
        raise ArgumentError, "Forecast area was nil."
    else
        return forecast_area(area_or_options)
    end
  end
  
  
  ### private class methods
  def GoogleWeather.forecast_lat_long(lat,long)
    return forecast_url(URI.parse("http://www.google.com/ig/api?weather=" + ",,," +
                                       (lat * 1000000).to_i.to_s + "," + 
                                       (long * 1000000).to_i.to_s))
  end
  private_class_method :forecast_lat_long
  
  def GoogleWeather.forecast_area(area)
    return forecast_url(URI.parse("http://www.google.com/ig/api?weather=" + URI.escape(area)))
  end
  private_class_method :forecast_area
  
  #### Returns a default forecast (when google can't be reached)
  def GoogleWeather.sample_forecast
    sunny = {
        :conditions => "Sunny",
        :temp_f => 60,
        :temp_c => 15,
        :humidity => "60%",
        :wind => "SW 10mph"
      }
    cloudy = {
        :conditions => "Cloudy",
        :temp_f => 60,
        :temp_c => 15,
        :humidity => "70%",
        :wind => "SW 15mph"
      }
    rainy = {
        :conditions => "Rainy",
        :temp_f => 60,
        :temp_c => 15,
        :humidity => "70%",
        :wind => "SW 15mph"
    }
    
    forecast = {
      :current => sunny,
      :future => {
        "Mon" => cloudy,
        "Tue" => sunny,
        "Wed" => rainy,
        "Thu" => cloudy,
        "Fri" => sunny,
        "Sat" => rainy,
        "Sun" => cloudy
      }
    }
  end
  
  def GoogleWeather.first_value_or(first,default)
    return (!first.nil?) ? ((first.values[0].nil? || first.values[0].empty?) ? first.values[0] : default ) : default
  end
  
  #### Parses and returns the forecast from the google api url given
  def GoogleWeather.forecast_url(url)
    doc = begin
      Nokogiri::XML(open(url))
    rescue OpenURI::HTTPError => err
      if ( err.io.status[0].to_s == "503" )
        raise NoForecastException.new("503 error: Over limit for google weather requests.")
      else
        puts err.io.status[0]
        raise err
      end
    end
    
    forecast = {}
    
    current = doc.xpath("/xml_api_reply/weather/current_conditions").first
    if ( ! current.nil? )
      forecast[:current] = {
        :conditions => first_value_or(current.xpath("condition").first, "Unknown"),
        :temp_f => first_value_or(current.xpath("temp_f").first, "Unknown"),
        :temp_c => first_value_or(current.xpath("temp_c").first, "Unknown"),
        :humidity => first_value_or(current.xpath("humidity").first, "Unknown"),
        :wind => first_value_or(current.xpath("wind_condition").first, "Unknown")
      }
    end
    
    forecast[:future] = {}
    
    doc.xpath("/xml_api_reply/weather/forecast_conditions").each do |conditions|
      unless ( conditions.xpath("day_of_week").first.nil? )
        forecast[:future][conditions.xpath("day_of_week").first.values[0]] = {
          :low_f => conditions.xpath("low").first.values[0],
          :high_f => conditions.xpath("high").first.values[0],
          :conditions => conditions.xpath("condition").first.values[0]
        }
      end
    end
    
    location_info = doc.xpath("/xml_api_reply/weather/forecast_information")
    if ( location_info.length > 0 )
      location_info = location_info.first
      forecast[:location] = {
        :city => location_info.xpath("city").first.values[0],
        :postal_code => location_info.xpath("postal_code").first.values[0],
        :latitude => location_info.xpath("latitude_e6").first.values[0],
        :longitude => location_info.xpath("longitude_e6").first.values[0],
        :forecast_date => location_info.xpath("forecast_date").first.values[0],
        :current_date_time => location_info.xpath("current_date_time").first.values[0]
      }
    end
    
    if ( forecast.empty? || forecast[:future].empty? )
      raise NoForecastException.new("No forecast for this area.")
    end
    
    return forecast
  end
  private_class_method :forecast_url
  
  
end