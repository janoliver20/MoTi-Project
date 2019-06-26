//
//  MovieDetailsViewController.swift
//  MoTi
//
//  Created by Gerald on 24.06.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit


//hier code rein fuer den details screen


class MovieDetailsViewController : UIViewController{
    
    var myMovie : Movie? //of type movie
    
    
    //let allmovies = MovieClass.allMovies
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var ownPhotoImageView: UIImageView!
    @IBOutlet weak var descriptionOfMovieTextView: UITextView!
    
    
    @IBOutlet weak var watchedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //do stuff
        showDetailsOfMovieEntry()
        
    }
    
    func showDetailsOfMovieEntry(){
        
       
        if let myMovie = myMovie{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            dateLabel.text = formatter.string(from: myMovie.date!)
            
            
            movieTitleLabel.text = myMovie.title
            
            descriptionOfMovieTextView.text = myMovie.movieDescription != nil ? myMovie.movieDescription : "I liked this movie."
         
            if myMovie.hasBeenWatched{
                watchedLabel.text = "I watched this movie on"
            } else {
                watchedLabel.text = "I am going to watch this movie on"
            }
           
            if let newCoverImage = myMovie.data1, let newOwnImage = myMovie.data2 {
                
                pictureImageView.image = UIImage(data: newCoverImage)
                
                ownPhotoImageView.image = UIImage(data: newOwnImage)
            }
            else {
                pictureImageView.image = UIImage(named: "sampleImage1")
                scrollView.isScrollEnabled = false

                
            }
            
            
            
        }
        
       
        
    }
    
    
    
    
}
