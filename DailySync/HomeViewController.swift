//
//  HomeViewController.swift
//  DailySync
//
//  Created by Ayla ganama on 12/03/2025.
//

import UIKit

class HomeViewController: UIViewController {
       
    @IBOutlet weak var hydrationLabel: UILabel!
    @IBOutlet weak var hydrationProgressBar: UIProgressView!
    @IBOutlet weak var homeWeatherIcon: UIImageView!
    @IBOutlet weak var homeTemperatureLabel: UILabel!
    @IBOutlet weak var homeVitaminsLabel: UILabel!
    @IBOutlet weak var homeStepsBar: UIProgressView!
    @IBOutlet weak var homeStepsLabel: UILabel!
    
    var currentWaterIntake: Double = 0.0 {
        didSet {
            updateHydrationUI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearUserDefaults() // ✅ Clears all saved data
        
        // Set progress bars to 0
        hydrationProgressBar.progress = 0.0
        
        // Set vitamins switch to ❌
        homeVitaminsLabel.text = "❌"
        
        updateHydrationUI()
    }
    
    func clearUserDefaults() {
        let defaults = UserDefaults.standard
        let keysToRemove = ["hydrationLevel", "vitaminsList", "vitaminsSwitchState",
                            "savedSteps", "savedTemperature", "savedWeatherCondition", "savedWeatherIcon"]

        for key in keysToRemove {
            defaults.removeObject(forKey: key)
        }

        defaults.synchronize()
        print("✅ UserDefaults cleared on first launch!")
    }
    
    func updateStepUI(steps: Int) {
        let goalSteps = 10000.0 // Step Goal
        let progress = min(Double(steps) / goalSteps, 1.0) // Keep max at 100%
        
        homeStepsLabel.text = "Steps: \(steps)"
        homeStepsBar.setProgress(Float(progress), animated: true)
    }
    
    
    func fetchHydrationData() {
        // ✅ Load hydration level from UserDefaults
        if let savedHydration = UserDefaults.standard.value(forKey: "hydrationLevel") as? Double {
            DispatchQueue.main.async {
                self.currentWaterIntake = savedHydration
                self.updateHydrationUI()
            }
            print("✅ Hydration Data Loaded: \(savedHydration) cups")
        } else {
            print("❌ No saved hydration data found, defaulting to 0 cups")
            DispatchQueue.main.async {
                self.currentWaterIntake = 0.0
                self.updateHydrationUI()
            }
        }
    }

    // MARK: - Hydration Summary (Read-Only)
    func updateHydrationUI() {
        let maxCups: Double = 8.0
            hydrationLabel.text = "\(Int(currentWaterIntake))/8 cups"
            hydrationProgressBar.setProgress(Float(currentWaterIntake / maxCups), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // ✅ Load Hydration Level
        fetchHydrationData()

        // ✅ Load Vitamins Switch State
        let vitaminsTaken = UserDefaults.standard.bool(forKey: "vitaminsSwitchState")
        homeVitaminsLabel.text = vitaminsTaken ? "✅" : "❌"  // ✅ Update checkmark dynamically

        // ✅ Load saved weather data from UserDefaults
        if let savedTemp = UserDefaults.standard.value(forKey: "savedTemperature") as? Double,
            let savedIconName = UserDefaults.standard.string(forKey: "savedWeatherIcon") { // ✅ Get saved icon
                
            homeTemperatureLabel.text = "\(Int(savedTemp))°F"
            homeWeatherIcon.image = UIImage(systemName: savedIconName) // ✅ Apply saved icon
        } else {
            homeTemperatureLabel.text = "--°F" // Default if no data
        }
    updateHydrationUI()
    }
    
    // MARK: - Update Weather Icon
       func updateWeatherIcon(condition: String) {
           let iconName: String
           switch condition {
           case "clear", "mostlyClear", "partlyCloudy":
               iconName = "sun.max.fill"
           case "cloudy", "mostlyCloudy":
               iconName = "cloud.fill"
           case "drizzle", "rain", "heavyRain":
               iconName = "cloud.rain.fill"
           case "thunderstorms":
               iconName = "cloud.bolt.rain.fill"
           case "snow", "heavySnow":
               iconName = "snowflake"
           case "foggy", "haze", "smoky":
               iconName = "cloud.fog.fill"
           default:
               iconName = "cloud.sun.fill"
           }
           
           homeWeatherIcon.image = UIImage(systemName: iconName)
       }
   }
