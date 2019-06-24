//
//  SeenMovieViewController
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

class SeenMovieViewController: UIViewController  {
    let cellID = "movieSeenCell"
    let allMovies = MovieClass.allMovies
    let segueName = "detailsSegueSeen"
    
    var seenMovieArr: [Movie] = [Movie]()
    var selectedMovie: Movie?
    
    @IBOutlet weak var movieTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMovieLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SeenMovieViewController.reload), name: .refreshTable, object: nil)
        movieTV.register(SeenMovieTableViewCell.self, forCellReuseIdentifier: cellID)
        self.movieTV.tableFooterView = UIView()

    }
    
    @objc func reload() {
        refreshMovieLibrary()
        movieTV.reloadData()
    }
    
    private func refreshMovieLibrary(){
        if !allMovies.loadMovies(){
            let alert = UIAlertController(title: "Movie could not load!", message: "Please restart the app again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        seenMovieArr = allMovies.getAllSeenOrUnseenMovies(seen: true) ?? []
    }
}

extension SeenMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seenMovieArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTV.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SeenMovieTableViewCell
        let currentLastItem = seenMovieArr[indexPath.row]
         cell.movie = currentLastItem
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieToDelete = seenMovieArr[indexPath.row]
            allMovies.deleteMovie(movieObject: movieToDelete)
            self.seenMovieArr.remove(at: indexPath.row)
            self.movieTV.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = seenMovieArr[indexPath.row]
        performSegue(withIdentifier: segueName, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueName {
            let vc = segue.destination as! UINavigationController
            let realVC = vc.topViewController as! MovieDetailsViewController
            realVC.myMovie = selectedMovie
        }
    }
}
