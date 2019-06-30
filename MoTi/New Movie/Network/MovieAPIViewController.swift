//
//  MovieAPIViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 27.06.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit
//https://itunes.apple.com/search?term=&entity=movie

protocol sendMovie {
    func sendMovie(movie: Result)
}

class MovieAPIViewController: UIViewController, UINavigationControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchTerm: String?
    
    let cellID = "searchResultCell"
    var searchResults: DataBase?
    var delegate: sendMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
        if let searchTerm = searchTerm {
            loadMoviesFromiTunes(with: searchTerm)
        }
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(MovieAPITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.reloadData()
    }
    
    private func loadMoviesFromiTunes(with searchTerm: String) {
        let urlString = turnIntoALink(searchTerm: searchTerm)
        
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                do {
                    let dataBase = try JSONDecoder().decode(DataBase.self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = dataBase
                        self.tableView.reloadData()
                    }
                } catch let dataError as NSError {
                    print(dataError)
                }
            }
            
            
        })
        
        dataTask.resume()
        
    }
    
    private func turnIntoALink(searchTerm: String) -> String {
        return "https://itunes.apple.com/search?term=\(String(searchTerm.map({ $0 == " " ? "+" : $0 })))&entity=movie"
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            loadMoviesFromiTunes(with: searchText)

        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}


extension MovieAPIViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchResults = searchResults {
            return searchResults.resultCount ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let result = searchResults?.results[indexPath.row]
        if let searchResults = result {
            cell.textLabel?.text = searchResults.trackName ?? "No Movie Found"
            cell.detailTextLabel?.text = "\(searchResults.artistName ?? "No artist")"
            cell.detailTextLabel?.isHidden = false
        }
        else {
            cell.textLabel?.text = "No Movie Found"
            cell.detailTextLabel?.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let results = searchResults?.results {
            delegate?.sendMovie(movie: results[indexPath.row] )
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
