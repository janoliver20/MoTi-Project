//
//  MovieClass.swift
//  MoTi
//
//  Created by Jan Cortiel on 05.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit
import CoreData

class MovieClass {
    
    static let allMovies = MovieClass()
    
    private var movies : [Movie] = [Movie]()
    
    private init(){}
    
    func getMovie(withIndex: Int) -> (wasFound: Bool, movie: Movie?) {
        if withIndex < 0 || withIndex > movies.endIndex {
            return (false, nil)
        }
        return (true, movies[withIndex])
    }
    
    func getAllSeenOrUnseenMovies(seen: Bool) -> [Movie]? {
        
        var newArrayToReturn: [Movie] = []
        
        for movie in movies {
            if movie.hasBeenWatched && seen || !movie.hasBeenWatched && !seen {
                newArrayToReturn.append(movie)
            }
        }
        
        return newArrayToReturn
    }
    
    func refreshMovies() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        
        do {
            movies = try managedContext.fetch(fetchRequest) as! [Movie]
        }
        catch let error as NSError {
            print("Could not fetch Data! \(error), \(error.userInfo)")
            return false
        }
        
        return true
    }
    
    func saveNewMovie(title: String, description: String = "", date: Date = Date(), hasBeenWatched: Bool = false) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
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
            return false
        }
        
        return true
    }
    
    func getMovieCount() -> Int {
        return movies.count
    }
    
    func searchForSpecificMovie(titleToSearchFor: String) -> Movie? {
        if titleToSearchFor.isEmpty {
            return nil
        }
        
        for movie in movies {
            guard let movieTitle = movie.title else {
                return nil
            }
            
            if movieTitle.elementsEqual(titleToSearchFor) {
                return movie
            }
        }
        
        return nil
        
    }
    
    func searchForMultipleMovies(titleToSearchFor: String) -> [Movie]? {
        if titleToSearchFor.isEmpty {
            return nil
        }
        
        var newArrayToReturn: [Movie] = []
        
        for movie in movies {
            guard let movieTitle = movie.title else {
                return nil
            }
            
            if movieTitle.contains(titleToSearchFor) {
                newArrayToReturn.append(movie)
            }
        }
        
        return newArrayToReturn
    }
    
    
}
