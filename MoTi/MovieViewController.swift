//
//  MovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 07.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit
import CoreData
extension Notification.Name {
    static let refreshTable = Notification.Name("refreshTable")
}

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "movieCell"
    
    var movies : [Movie] = [Movie]()
    
    @IBOutlet weak var movieTV: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadMovies()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MovieViewController.reload), name: .refreshTable, object: nil)
//        loadMovies()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let currentLastItem = movies[indexPath.row]
        cell.textLabel?.text = currentLastItem.title
        return cell
    }
    
    @objc func reload() {
        loadMovies()
        movieTV.reloadData()
    }
    
    func loadMovies(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        }
        catch let error as NSError {
            print("Could not fetch Data! \(error), \(error.userInfo)")
        }
    }
    
    
    
   

   
    

    
    

}
