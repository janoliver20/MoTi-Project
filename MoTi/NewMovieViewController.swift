//
//  NewMovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 29.04.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit
import CoreData

var settingsArray = ["Date", "Friends", "Description"]

var myIndex = 0

struct PropertyKey {
    static let title = "title"
    static let desc = "movieDescription"
    static let date = "date"
    static let hasBeenWatched = "hasBeenWatched"
}

class NewMovieViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var watchedSegmentControl: UISegmentedControl!

    var hasBeenWatched = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTitle.delegate = self
        
        loadSamplePhoto()
    }
    
    private func loadSamplePhoto(){
        let samplePhoto = UIImage(named: "sampleImage1")
        movieImage.image = samplePhoto
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func saveNewMovie(_ sender: UIBarButtonItem) {
        guard let movieTitle = movieTitle.text else {
            let alert = UIAlertController(title: "No movie title entered!", message: "You need to enter a title!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        switch watchedSegmentControl.selectedSegmentIndex {
        case 0:
            hasBeenWatched = false
        case 1:
            hasBeenWatched = true
        default:
            break
        }
        
        save(title: movieTitle, description: "", date: Date(), hasBeenWatched: hasBeenWatched)
        
        NotificationCenter.default.post(name: .refreshTable, object: nil)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelNewMovie(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        
        cell.textLabel?.text = settingsArray[indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        
    }
    
    func save(title: String, description: String, date: Date, hasBeenWatched: Bool){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        
        
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movie.setValue(title, forKey: PropertyKey.title)
        movie.setValue(description, forKey: PropertyKey.desc)
        movie.setValue(date, forKey: PropertyKey.date)
        movie.setValue(hasBeenWatched, forKey: PropertyKey.hasBeenWatched)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }

    
}
