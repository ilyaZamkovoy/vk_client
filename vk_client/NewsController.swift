//
//  NewsController.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 26/12/2016.
//  Copyright © 2016 Zamkovoy Ilya. All rights reserved.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class NewsController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    
    
    var userArray: [User]! = []
    var newsArray: [News]! = []
    var groupArray: [Group]! = []
    
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var checkNews: Bool! = false
        var checkFriends: Bool! = false
        var checkGroups: Bool! = false
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
        
        VK.API.custom(method: "newsfeed.get").send(
            onSuccess:{ response in
                print(response["items"].arrayValue[0])
                var i = 0;
                var j = 0;
                while j != 10{
                    
                    let news = News()
                    if response["items"].arrayValue[i]["attachments"] != nil{
                        news.date = response["items"].arrayValue[i]["date"].doubleValue
                        news.ownerApiId = response["items"].arrayValue[i]["source_id"].stringValue
                    
                        if response["items"].arrayValue[i]["attachments"].arrayValue[0]["type"].stringValue == "photo"{
                            news.photo = response["items"].arrayValue[i]["attachments"].arrayValue[0]["photo"]["photo_130"].stringValue
                        } else {
                            news.photo = response["items"].arrayValue[i]["attachments"].arrayValue[0]["video"]["video_75"].stringValue
                        }
                        print(j)
                        j += 1;
                    
                        news.text = response["items"].arrayValue[i]["text"].stringValue
                    
                        self.newsArray.append(news)
                    } else {
                        print(response["items"].arrayValue[i])
                    }
                    i += 1;
                    
                }
                checkNews = true
                
                if checkNews == true && checkGroups == true && checkFriends == true {
                    self.checkOwner()
                    DispatchQueue.main.async {
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
                
            },
            onError: {error in print(" fail \n \(error)")}
        )
        
        VK.API.custom(method: "friends.get", parameters: [VK.Arg.fields: "photo"]).send(
            onSuccess:{ response in
                for i in 0...(response["items"].arrayValue.count - 1){
                    
                    let user =  User()
                    
                    user.id = response["items"].arrayValue[i]["id"].intValue
                    user.first_name = response["items"].arrayValue[i]["first_name"].stringValue
                    user.last_name = response["items"].arrayValue[i]["last_name"].stringValue
                    user.photo = response["items"].arrayValue[i]["photo"].stringValue
                    
                    
                    self.userArray.append(user)
                }
                
                 checkFriends = true
                
                
                if checkNews == true && checkGroups == true && checkFriends == true {
                    self.checkOwner()
                    DispatchQueue.main.async {
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
            },
            onError: {error in print(" fail \n \(error)")}
        )
        
        VK.API.custom(method: "groups.get", parameters: [VK.Arg.extended: "1"]).send(
            onSuccess:{ response in
                
                for i in 0...(response["items"].arrayValue.count - 1){
                    let group = Group()
                    
                    group.id = response["items"].arrayValue[i]["id"].intValue
                    group.name = response["items"].arrayValue[i]["name"].stringValue
                    group.photo = response["items"].arrayValue[i]["photo_100"].stringValue
                    
                    self.groupArray.append(group)
                
                }
                
                checkGroups = true
                
                if checkNews == true && checkGroups == true && checkFriends == true {
                    self.checkOwner()
                    DispatchQueue.main.async {
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    }
                }
            },
            onError: {error in print(" fail \n \(error)")}
        )
       
    }
    
    func refresh(sender:AnyObject) {
        // Code to refresh table view
        
        print("hello world")
        
        
        refreshControl.endRefreshing()
    }
    
    func checkOwner(){
        for i in 0...9 {
            let news = self.newsArray[i]
            var ip = news.ownerApiId
            
            var chars = ip?.characters.map { String($0) }
            
            if chars?[0] == "-"{
                ip?.remove(at: (ip?.startIndex)!)
                var group = Group()
                for j in 0...(self.groupArray.count - 1){
                    let number = groupArray[j].id as NSNumber!
                    if ip == number?.stringValue{
                        group = groupArray[j]
                    }
                }
                self.newsArray[i].group = group
            } else {
                var user = User()
                
                for j in 0...(self.userArray.count - 1){
                    let number = userArray[j].id as NSNumber!
                    if ip == number?.stringValue{
                        user = userArray[j]
                    }
                }
                self.newsArray[i].user = user
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath as IndexPath) as! NewsTableViewCell
        
        let news = self.newsArray[indexPath.row]
        
        if !news.text.isEmpty {
            cell.postTextLabel.text = news.text
        } else {
            cell.postTextLabel.text = "no post text here"
        }
        
        let date = NSDate(timeIntervalSince1970: news.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateInFormat = dateFormatter.string(from: date as Date)
        
        cell.postDateLabel.text = dateInFormat
        
        if news.user != nil {
            let user = news.user!
            cell.postOwnersNameLabel.text = "\(user.first_name!) \(user.last_name!)"
            let url = URL(string: user.photo)
            let data = try? Data(contentsOf: url!)
            cell.postOwnersImage.image = UIImage(data: data!)
        } else {
            let group = news.group!
            cell.postOwnersNameLabel.text = group.name
            let url = URL(string: group.photo)
            let data = try? Data(contentsOf: url!)
            cell.postOwnersImage.image = UIImage(data: data!)
        }
        
        
        if !news.photo.isEmpty {
            let imageUrl = news.photo
        
            let url = URL(string: imageUrl!)
            let data = try? Data(contentsOf: url!)
            cell.postImage.image = UIImage(data: data!)
        }else{
            cell.postImage.image = #imageLiteral(resourceName: "addImage")
        }
        return cell
    }
    
    
    
    
    
    

}
