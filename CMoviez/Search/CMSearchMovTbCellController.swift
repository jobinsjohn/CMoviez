//
//  CMSearchMovTbCellController.swift
//  CMoviez
//
//  Created by Jobins John on 4/16/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import UIKit

class CMSearchMovTbCellController: UITableViewCell {

    @IBOutlet weak var moviePosterImageView     : UIImageView!
    
    @IBOutlet weak var movieNameLabel           : UILabel!
    
    @IBOutlet weak var movieReleaseDateLabel    : UILabel!
    
    @IBOutlet weak var movieOverviewLabel       : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
