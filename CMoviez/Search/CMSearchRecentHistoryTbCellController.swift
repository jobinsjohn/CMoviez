//
//  CMSearchRecentHistoryTbCellController.swift
//  CMoviez
//
//  Created by Jobins John on 4/18/18.
//  Copyright © 2018 Jobins John. All rights reserved.
//

import UIKit

class CMSearchRecentHistoryTbCellController: UITableViewCell {
    @IBOutlet weak var rcntHisMovienameLabelOutlet: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rcntHisMovienameLabelOutlet.textColor = UIColor(hexString: APP_MOVIE_TITLE_FONT_COLOR)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
