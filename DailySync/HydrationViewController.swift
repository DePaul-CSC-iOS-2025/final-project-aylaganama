//
//  HydrationViewController.swift
//  DailySync
//
//  Created by Ayla ganama on 16/03/2025.
//

import UIKit

class HydrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hydrationProgressBar: UIProgressView!
    @IBOutlet weak var healthLogHydrationLabel: UILabel!
    @IBOutlet weak var vitaminTableView: UITableView!
    @IBOutlet weak var vitaminSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "hydrationLevel")
        UserDefaults.standard.removeObject(forKey: "vitaminsList")
        UserDefaults.standard.synchronize()
        
        vitaminTableView.delegate = self
        vitaminTableView.dataSource = self
        
        hydrationProgressBar.progress = 0.0
        vitaminSwitch.isOn = false
        updateHydrationUI()
    }
    
    var currentWaterIntake: Float = 0.0
    let maxCups: Float = 8.0  // Daily goal
    var vitamins: [(name: String, taken: Bool)] = [("Vitamin C", false), ("Vitamin D", false), ("Omega-3", false)]
    
    
    @IBAction func waterCup(_ sender: Any) {
        if currentWaterIntake < maxCups {
            currentWaterIntake += 1  // Increase by 1 cup
            updateHydrationUI()
        }
    }
    
    func updateHydrationUI() {
        healthLogHydrationLabel.text = "\(Int(currentWaterIntake))/8 Cups"
        hydrationProgressBar.setProgress(currentWaterIntake / maxCups, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vitamins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VitaminCell", for: indexPath)
        
        let vitamin = vitamins[indexPath.row]
        cell.textLabel?.text = vitamin.name
        cell.accessoryType = vitamin.taken ? .checkmark : .none  // Checkmark if taken
        
        return cell
    }
    
    // Handle tapping to check/uncheck vitamins
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vitamins[indexPath.row].taken.toggle()
        tableView.reloadData()
    }
    
    @IBAction func addVitamin(_ sender: Any) {
        let alert = UIAlertController(title: "Add Vitamin", message: "Enter vitamin name", preferredStyle: .alert)
        alert.addTextField()

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let vitaminName = alert.textFields?.first?.text, !vitaminName.isEmpty {
                DispatchQueue.main.async {
                    self.vitamins.append((name: vitaminName, taken: false))
                    self.vitaminTableView.reloadData()
                }
            }
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        let savedHydration = currentWaterIntake
        let savedVitamins = vitamins
        let vitaminsTaken = vitaminSwitch.isOn  //  Get switch state
        
        //  Save hydration level
        UserDefaults.standard.set(savedHydration, forKey: "hydrationLevel")
        
        //  Save vitamins list
        let vitaminData = vitamins.map { ["name": $0.name, "taken": $0.taken] }
        UserDefaults.standard.set(vitaminData, forKey: "vitaminsList")
        
        //  Save vitamins switch state
        UserDefaults.standard.set(vitaminsTaken, forKey: "vitaminsSwitchState")
        
        UserDefaults.standard.synchronize() // Ensure data is saved immediately
        
        print("✅ Saved Hydration: \(savedHydration) cups")
        print("✅ Saved Vitamins: \(savedVitamins)")
        print("✅ Vitamins Switch State: \(vitaminsTaken)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load Hydration
        if let savedHydration = UserDefaults.standard.value(forKey: "hydrationLevel") as? Float {
            currentWaterIntake = savedHydration
            updateHydrationUI()
        }

        // Load Vitamins
        if let savedVitamins = UserDefaults.standard.array(forKey: "vitaminsList") as? [[String: Any]] {
            vitamins = savedVitamins.compactMap { dict in
                guard let name = dict["name"] as? String, let taken = dict["taken"] as? Bool else { return nil }
                return (name, taken)
            }
            vitaminTableView.reloadData()
        }
    }
    
    
}
