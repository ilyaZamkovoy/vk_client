//
//  UserAuthCheckController.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 01/02/2017.
//  Copyright © 2017 Zamkovoy Ilya. All rights reserved.
//

import UIKit
import SwiftyVK

class UserAuthCheckController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.checkUser()
    }
    
    func checkUser(){
        let check = VK.check()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window else {return}
        
        if check == true {
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationController")
            window.makeKeyAndVisible()
        } else {
            window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Root_View") as! LoginController
            window.makeKeyAndVisible()
        }
    }
}
