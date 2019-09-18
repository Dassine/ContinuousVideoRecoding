//
//  AppDelegate.swift
//  ContinuousVideoRecoding
//
//  Created by Lilia Dassine BELAID on 9/18/19.
//  Copyright © 2019 Lilia Dassine BELAID. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
      
           return true
       }



}

