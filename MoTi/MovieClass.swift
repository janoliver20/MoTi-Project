//
//  MovieClass.swift
//  MoTi
//
//  Created by Jan Cortiel on 05.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit
import Contacts

class MovieClass {
    let movieTitle: String
    let description: String
    let date: Date
    let hasBeenWatched: Bool
    var friends: [CNMutableContact]
    
    init(title movieTitle: String, description: String = "", date: Date, hasBeenWatched: Bool = false, friends: [CNMutableContact]) {
        self.movieTitle = movieTitle
        self.description = description
        self.date = date
        self.hasBeenWatched = hasBeenWatched
        self.friends = friends
    }
}
