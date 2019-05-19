//
//  NewMovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 19.05.19.
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
    @IBOutlet weak var watchedSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var hasBeenWatched = false;
    
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
            return
        }
        if movieTitle.isEmpty {
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
        
        
        if !MovieClass.allMovies.saveNewMovie(title: movieTitle, description: "", date: Date(), hasBeenWatched: hasBeenWatched){
            let alert = UIAlertController(title: "Movie was not saved!", message: "Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
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
    
    
}
