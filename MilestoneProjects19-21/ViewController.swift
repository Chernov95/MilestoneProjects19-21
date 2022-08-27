//
//  ViewController.swift
//  MilestoneProjects19-21
//
//  Created by Filip Cernov on 27/08/2022.
//

import UIKit

class Notes: Codable {
    var notes: [Note]
    init (notes: [Note]) {
        self.notes = notes
    }
}

class Note: Codable {
    var title: String
    var text: String
    init(title: String, text: String) {
        self.title = title
        self.text = text
    }
}

class NotesTableViewController: UIViewController {
    
    var notes = [Note]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadJSON()
    }
    
    func loadJSON() {
        DispatchQueue.global().async {
            if let url = Bundle.main.url(forResource: "notes", withExtension: "json") {
                   do {
                       let data = try Data(contentsOf: url)
                       let decoder = JSONDecoder()
                       let jsonData = try decoder.decode(Notes.self, from: data)
                       self.notes = jsonData.notes
                   } catch {
                       print("error:\(error)")
                   }
               }
        }
    }
    
    @IBAction func addNewNote(_ sender: UIButton) {
        let note = Note(title: "New note", text: "")
        notes.append(note)
        let requestBody = Notes(notes: notes)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let result = try encoder.encode(requestBody)
            // RESULT IS NOW JSON-LIKE DATA OBJECT
            if let jsonString = String(data: result, encoding: .utf8){
                // JSON STRING
                print("JSON \(jsonString)")
            }
        } catch {
            print("Your parsing sucks \(error)")
        }
        tableView.reloadData()
    }
    
}

extension NotesTableViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }

}

