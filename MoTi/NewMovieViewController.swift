//
//  NewMovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 29.04.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit

var settingsArray = ["Date", "Friends", "Description"]

var myIndex = 0

class NewMovieViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var movieTitle: UITextField!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
   
    
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
