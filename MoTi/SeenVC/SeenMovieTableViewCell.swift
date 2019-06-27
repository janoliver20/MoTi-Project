//
//  SeenMovieTableViewCell.swift
//  MoTi
//
//  Created by Jan Cortiel on 19.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit

class SeenMovieTableViewCell: UITableViewCell {
    
    var movie: Movie? {
        didSet {
            movieTitleLbl.text = movie?.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if let movieDate = movie?.date {
                dateLbl.text = dateFormatter.string(from: movieDate)
            }
            if let coverImage = movie?.data1 {
                movieCover.image = UIImage(data: coverImage)
            }
            else {
                movieCover.image = UIImage(named: "sampleImage1")
            }
        }
    }
    
    private let movieTitleLbl : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let dateLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let movieCover : UIImageView = {
        let imgView = UIImageView()
        
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(movieCover)
        addSubview(movieTitleLbl)
        addSubview(dateLbl)
        
        movieCover.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 0, width: 54, height: 80, enableInsets: false)
        
        movieTitleLbl.anchor(top: topAnchor, left: movieCover.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        dateLbl.anchor(top: movieTitleLbl.bottomAnchor, left: movieCover.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

