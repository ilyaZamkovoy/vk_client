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
        
        self.tabBarController?.tabBar.layer.zPosition = -1
        
        
        if !news.text.isEmpty {
           postLabel.text = news.text
        } else {
            postLabel.text = "это текст-, часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной  для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum."
        }
        postLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        let date = NSDate(timeIntervalSince1970: news.date as TimeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateInFormat = dateFormatter.string(from: date as Date)
        
        dateOfPost.text = dateInFormat
        
        if news.user != nil {
            let user = news.user!
            userNameLabel.text = user.name
            let url = URL(string: user.photo)
            
            userProfileImage.kf.setImage(with: url)
        } else {
            let group = news.group!
            userNameLabel.text = group.name
            if group.photo != nil {
                let url = URL(string: group.photo)
                userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.width / 2.0
                userProfileImage.layer.masksToBounds = true
                userProfileImage.kf.setImage(with: url)
            } else {
                userProfileImage.image = #imageLiteral(resourceName: "addImage")
            }
        }
        
        
        if news.photo != nil{
            let url = URL(string: news.photo)
            postImageView.kf.setImage(with: url)
            var width = postImageView.image?.size.width
            var height = postImageView.image?.size.height
            
            if width! > CGFloat(550) {
                let elem = width!/351
                width = width!*elem
                
            }
            if height! > CGFloat(550) {
                let elem = height!/400
                height = height!*elem
            }
            let screenSize: CGRect = postImageView.bounds
            postImageView.frame = CGRect(x: 0, y: 0, width: screenSize.height * 0.2, height: 50)
//            postImageView.frame = CGRect?(0,0, screenSize.height * 0.2, 50)
            
        }else{
            postImageView.image = #imageLiteral(resourceName: "addImage")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
