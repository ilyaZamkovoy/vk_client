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
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.postImage.image = nil
        self.postDateLabel.text = nil
        self.postOwnersImage.image = nil
        self.postTextLabel.text = nil
        self.postOwnersNameLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func compareData(news: News){
        
        self.postTextLabel.text = news.text
        
        self.postDateLabel.text = news.finalDate
        
        let owner = news.finalOwner
        self.postOwnersNameLabel.text = owner.name
        let url = URL(string: owner.photo)
        self.postOwnersImage.kf.setImage(with: url)
        
        if news.photo != nil {
            let url = URL(string: news.photo)
            self.postImage.kf.setImage(with: url)
        }else{
            self.postImage.image = #imageLiteral(resourceName: "addImage")
        }
    }
}
