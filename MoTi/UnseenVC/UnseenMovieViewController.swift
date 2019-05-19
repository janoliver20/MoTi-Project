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
    
    @IBOutlet weak var movieTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshMovieLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(UnseenMovieViewController.reload), name: .refreshTable, object: nil)
        movieTV.register(UnseenMovieTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    @objc func reload() {
        refreshMovieLibrary()
        movieTV.reloadData()
    }
    
    private func refreshMovieLibrary(){
        if !allMovies.refreshMovies(){
            let alert = UIAlertController(title: "Movie could not load!", message: "Please restart the app again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
    }
}

extension UnseenMovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies.getMovieCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTV.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UnseenMovieTableViewCell
        let currentLastItem = allMovies.getMovie(withIndex: indexPath.row)
        if currentLastItem.wasFound {
            cell.movie = currentLastItem.movie
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
