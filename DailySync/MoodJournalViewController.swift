//
//  MoodJournalViewController.swift
//  DailySync
//
//  Created by Ayla ganama on 16/03/2025.
//

import UIKit

class MoodJournalViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var moodSegment: UISegmentedControl!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var moodEntries: [(date: Date, mood: String, text: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        let selectedDate = datePicker.date
        let selectedMood = moodSegment.titleForSegment(at: moodSegment.selectedSegmentIndex) ?? "Neutral"
        let entryText = journalTextView.text ?? ""

        let newEntry = (date: selectedDate, mood: selectedMood, text: entryText)
        moodEntries.append(newEntry)

        tableView.reloadData()
        journalTextView.text = "New Entry"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return moodEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moodCell", for: indexPath)
        let entry = moodEntries[indexPath.row]

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        cell.textLabel?.text = "\(formatter.string(from: entry.date)) - \(entry.mood): \(entry.text)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return UITableView.automaticDimension
    }

}
