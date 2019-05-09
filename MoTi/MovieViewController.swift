//
//  MovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 07.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var movies: [Movie] = []
    @IBOutlet weak var movieTableView: UITableView!
    
    let emptyTextBox: UITextView = {
        let textView = UITextView()
        textView.text = "No movies yet!"
        textView.textAlignment = .center
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    private let reuseIdentifier = "unseenCell"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count != 0 ? movies.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unseenCell", for: indexPath)
        if movies.count == 0 {
            movieTableView.isHidden = true
            view.addSubview(emptyTextBox)
            emptyTextBox.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            emptyTextBox.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        else {
            
        }
        
        
        return cell
    }

   
    

    
    

}
