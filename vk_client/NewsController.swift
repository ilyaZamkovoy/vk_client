//
//  NewsController.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 26/12/2016.
//  Copyright © 2016 Zamkovoy Ilya. All rights reserved.
//

import UIKit
import SwiftyVK

class NewsController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var newsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func getNews() -> RequestExecution{
        
        let request = VK.API.NewsFeed.get().send(
            onSuccess: {response in
                print(" susccess \(response["items"].arrayValue[0])")
            },
            onError: {error in print(" fail \n \(error)")}
        )
        
        
        return request!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath as IndexPath) as! NewsTableViewCell
        
        let news = getNews()
        
//        let date = NSDate(timeIntervalSince1970: 1415637900)
        
        print(news)
        
        return cell
    }
    
    
    
    
    
    

}
