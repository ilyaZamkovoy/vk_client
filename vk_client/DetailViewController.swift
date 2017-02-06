//
//  showNews.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 23/01/2017.
//  Copyright © 2017 Zamkovoy Ilya. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    var news: News!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateOfPost: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.putDataIntoFields()
    }
    
    func putDataIntoFields(){
        postLabel.text = news.text
        
        dateOfPost.text = news.finalDate
        
        let owner = news.finalOwner
        userNameLabel.text = owner.name
        
        let url = URL(string: owner.photo)
        userProfileImage.kf.setImage(with: url)
        
        if news.photo != nil {
            let url = URL(string: news.photo)
            postImageView.kf.setImage(with: url)
        }else{
            postImageView.image = #imageLiteral(resourceName: "addImage")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
