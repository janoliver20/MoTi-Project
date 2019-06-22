//
//  UnseenMovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 19.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class UnseenMovieViewController: UIViewController  {
    
    let cellID = "movieUnseenCell"
    let allMovies = MovieClass.allMovies
    
    var unseenMovieArr: [Movie] = [Movie]()
    
    @IBOutlet weak var movieTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMovieLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(UnseenMovieViewController.reload), name: .refreshTable, object: nil)
        movieTV.register(UnseenMovieTableViewCell.self, forCellReuseIdentifier: cellID)
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
        unseenMovieArr = allMovies.getAllSeenOrUnseenMovies(seen: false) ?? []
    }
}

extension UnseenMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unseenMovieArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTV.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UnseenMovieTableViewCell
        let currentLastItem = unseenMovieArr[indexPath.row]
        cell.movie = currentLastItem
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieToDelete = unseenMovieArr[indexPath.row]
            allMovies.deleteMovie(movieObject: movieToDelete)
            self.unseenMovieArr.remove(at: indexPath.row)
            self.movieTV.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
