//
//  NewsTableViewCell.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 27/12/2016.
//  Copyright © 2016 Zamkovoy Ilya. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postOwnersImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postOwnersNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UITextView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
