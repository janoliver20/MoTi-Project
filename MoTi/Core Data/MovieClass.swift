//
//  MovieClass.swift
//  MoTi
//
//  Created by Jan Cortiel on 05.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import CoreData
import UIKit

class MovieClass {
    static let allMovies = MovieClass()

    private var movies: [Movie] = [Movie]()
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context: NSManagedObjectContext

    private init() {
        context = appDelegate.persistentContainer.viewContext
    }

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

    func loadMovies() -> Bool {

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")

        do {
            movies = try context.fetch(fetchRequest) as! [Movie]
        } catch let error as NSError {
            print("Could not fetch Data! \(error), \(error.userInfo)")
            return false
        }

        return true
    }

    func saveNewMovie(title: String, description: String = "", date: Date = Date(), hasBeenWatched: Bool = false) -> Bool {
        let newMovie = Movie(context: context)
        newMovie.title = title
        newMovie.movieDescription = description
        newMovie.date = date
        newMovie.hasBeenWatched = hasBeenWatched

        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
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
    
    func deleteMovie(movieObject: Movie){
        do{
            context.delete(movieObject)
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
