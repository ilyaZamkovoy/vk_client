//
//  VKDelegate.swift
//  vk_client
//
//  Created by Zamkovoy Ilya on 26/12/2016.
//  Copyright © 2016 Zamkovoy Ilya. All rights reserved.
//
import SwiftyVK

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif



class VKDelegateEx: VKDelegate {
    let appID = "5779925"
    let scope: Set<VK.Scope> = [.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    
    
    
    init() {
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
    }
    
    
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return scope
    }
    
    
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    
    
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    
    
    func vkDidUnauthorize() {}
    
    
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    
    
    #if os(OSX)
    func vkWillPresentView() -> NSWindow? {
        return NSApplication.shared().windows[0]
    }
    
    #elseif os(iOS)
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    #endif
}
