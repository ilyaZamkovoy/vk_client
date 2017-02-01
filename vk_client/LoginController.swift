//
//  ViewController.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 26/12/2016.
//  Copyright © 2016 Zamkovoy Ilya. All rights reserved.
//

import UIKit
import SwiftyVK

class LoginController: UIViewController{
    
    let vkDelegate = VKDelegateEx()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginController.loginSuccessfull(note:)),
                                               name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginSuccessfull(note: Notification) {
        performSegue(withIdentifier: "News", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: UIButton) {
        VK.logOut()
        print("SwiftyVK: LogOut")
        VK.logIn()
        print("SwiftyVK: authorize")
    }
}

