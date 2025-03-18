//
//  WeatherViewController.swift
//  DailySync
//
//  Created by Ayla ganama on 16/03/2025.
//

import UIKit
import CoreLocation
import WeatherKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Weather Screen Loaded")
        fetchWeather()
    }
    
    struct OpenWeatherResponse: Codable {
        let main: Main
        let weather: [Weather]
    }

    struct Main: Codable {
        let temp: Double
    }

    struct Weather: Codable {
        let main: String
    }
    
    //12f17a27772e2cf19511bce7f7f07013
    func fetchWeather() {
        let apiKey = "12f17a27772e2cf19511bce7f7f07013"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=41.8781&lon=-87.6298&appid=\(apiKey)&units=imperial"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let weatherData = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
                let temp = weatherData.main.temp
                let condition = weatherData.weather.first?.main ?? "Clear"

                DispatchQueue.main.async {
                    self.temperatureLabel.text = "\(Int(temp))°F"
                    let iconName = self.getWeatherIconName(for: condition)
                    self.weatherIcon.image = UIImage(systemName: iconName)

                    
                    UserDefaults.standard.set(temp, forKey: "savedTemperature")
                    UserDefaults.standard.set(condition, forKey: "savedWeatherCondition")
                    UserDefaults.standard.set(iconName, forKey: "savedWeatherIcon")
                    UserDefaults.standard.synchronize()
                }
            } catch {
                print("❌ JSON parsing error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func getWeatherIconName(for condition: String) -> String {
            switch condition.lowercased() {
            case "clear", "sunny":
                return "sun.max.fill"
            case "partly cloudy", "mostly clear", "few clouds":
                return "cloud.sun.fill"
            case "cloudy", "overcast", "mostly cloudy":
                return "cloud.fill"
            case "drizzle", "light rain", "showers", "rain", "heavy rain":
                return "cloud.rain.fill"
            case "thunderstorm", "storm":
                return "cloud.bolt.rain.fill"
            case "snow", "heavy snow", "blowing snow":
                return "snowflake"
            case "fog", "mist", "haze", "smoke":
                return "cloud.fog.fill"
            default:
                return "cloud.sun.fill" // Default fallback
            }
        }
    }
    
