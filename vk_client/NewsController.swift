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


class NewsController: UIViewController{

    @IBOutlet var tableView: UITableView!
    var newsArray: [News]! = []
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDataIntoNewsArray(callback: {
            DispatchQueue.main.async {[weak self] in
                self?.tableView.dataSource = self
                self?.tableView.reloadData()
            }
        
        })
        self.addRefreshControl()
        self.addInfinityScroll()
    }
    
    //making first request for news on app starting
    func addDataIntoNewsArray(callback: @escaping () -> Void){
        DispatchQueue.main.async {
            APIWorker.getNews {[weak self] result in
                self?.newsArray = result
                callback()
            }
        }
    }
    
    //adding refresh control and cell
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refreshNews(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.register(NewsTableViewCell.nib(), forCellReuseIdentifier: NewsTableViewCell.cellIdentifier())
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 450
    }
    
    //func that adding all news from newsArray
    func addInfinityScroll(){
        tableView.addInfiniteScroll { (tableView) -> Void in
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                self.tableView.reloadData()
            }
            tableView.finishInfiniteScroll()
        }
    }
    //func that reload table view and calling func for updating data in newsArray
    func refreshNews(sender:AnyObject) {
        self.refreshControl.endRefreshing()
        self.gettingFreshNews {
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
    
    func gettingOlderNews(callback: @escaping () -> Void){
        DispatchQueue.main.async {
            
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func unwindToLogin(_ sender: UIButton) {
        APIWorker.logout()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetAppToFirstController()
    }
    
    // MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.news = self.newsArray[(indexPath as NSIndexPath).row]
            }
            
        }
    }

}

// MARK: TableView Delegate methods

extension NewsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.cellIdentifier()) as! NewsTableViewCell
        
        let news = self.newsArray[indexPath.row]
        news.index = indexPath.row
        
        cell.compareData(news: news)
        
        return cell
    }

}
