//
//  MovieClass.swift
//  MoTi
//
//  Created by Jan Cortiel on 05.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit

class MovieClass {
    let movieTitle: String
    let desc: String
    let date: Date
    let hasBeenWatched: Bool
    
    init(title movieTitle: String, description: String = "", date: Date, hasBeenWatched: Bool = false) {
        self.movieTitle = movieTitle
        self.desc = description
        self.date = date
        self.hasBeenWatched = hasBeenWatched
    }
}
