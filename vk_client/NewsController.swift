//
//  NewsController.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 26/12/2016.
//  Copyright © 2016 Zamkovoy Ilya. All rights reserved.
//

import UIKit
import SwiftyVK
import Kingfisher


class NewsController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    var countOfRows = 10
    var newsArray: [News]! = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDataIntoNewsArray(callback: {
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            self.addFunctions()
            self.addInfinityScroll()
        })
        
    }
    //making first request for news on app starting
    func addDataIntoNewsArray(callback: @escaping () -> Void){
        DispatchQueue.main.async {
            APIWorker.getNews { result in
                self.newsArray = result
                callback()
            }
        }
        
        
    }
    //adding refresh control and cell
    func addFunctions(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 450
    }
    //func that adding all news from newsArray
    func addInfinityScroll(){
        tableView.addInfiniteScroll { (tableView) -> Void in
            self.countOfRows = self.newsArray.count - 1
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            tableView.finishInfiniteScroll()
        }
    }
    //func that reload table view and calling func for updating data in newsArray
    func refresh(sender:AnyObject) {
        let rowCount = self.newsArray.count 
        
        self.gettingFreshNews {
            
            self.countOfRows += self.newsArray.count - rowCount
            self.refreshControl.endRefreshing()
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            
        }
        
        
    }
    //func that update news in newsArray
    func gettingFreshNews(callback: @escaping () -> Void){
        DispatchQueue.main.async {
            APIWorker.refresh(newsArray: self.newsArray){ result in
                self.newsArray = result
                callback()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countOfRows
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableViewCell
        
        let news = self.newsArray[indexPath.row]
        news.index = indexPath.row
        
        if !news.text.isEmpty {
            let amount = news.text.characters.count
            if amount > 70 {
                let index = news.text.index(news.text.startIndex, offsetBy: 67)
                cell.postTextLabel.text = news.text.substring(to: index) + "..."
            } else {
                cell.postTextLabel.text = news.text
            }
        } else {
            cell.postTextLabel.text = "  "
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
                cell.postOwnersImage.layer.cornerRadius = cell.postOwnersImage.bounds.size.width / 2.0
                cell.postOwnersImage.layer.masksToBounds = true
                cell.postOwnersImage.kf.setImage(with: url)                
            } else {
                let group = news.group!
                cell.postOwnersNameLabel.text = group.name
                if group.photo != nil {
                    let url = URL(string: group.photo)
                    cell.postOwnersImage.layer.cornerRadius = cell.postOwnersImage.bounds.size.width / 2.0
                    cell.postOwnersImage.layer.masksToBounds = true
                    cell.postOwnersImage.kf.setImage(with: url)
                }
            }
        
        
        
            if news.photo != nil {
                let url = URL(string: news.photo)
                cell.postImage.kf.setImage(with: url)
            }else{
                cell.postImage.image = #imageLiteral(resourceName: "addImage")
            }
        
        
        return cell
    }
    
    @IBAction func unwindToLogin(_ sender: UIButton) {
        APIWorker.logout()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetAppToFirstController()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showNewsSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.news = self.newsArray[(indexPath as NSIndexPath).row]
            }
            
        }
    }

}
