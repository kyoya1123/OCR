//
//  CustomTableViewCell.swift
//  OCR
//
//  Created by Family Account on 2016/09/20.
//  Copyright © 2016年 Family Account. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var URLLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
