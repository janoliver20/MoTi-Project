//
//  seenMovieTableViewCell.swift
//  MoTi
//
//  Created by Jan Cortiel on 09.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit

class seenMovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieCover: UIImageView!
    @IBOutlet weak var movieDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
