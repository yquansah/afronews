//
//  AppDelegate.swift
//  pulse
//
//  Created by Kameni Ngahdeu on 6/17/19.
//  Copyright © 2019 bdt. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
     //   print(Realm.Configuration.defaultConfiguration.fileURL)
        FirebaseApp.configure()
        do {
            _ = try Realm()
        } catch {
            print("Could not initialise new realm, \(error)")
        }
        
        launchPulse()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func launchPulse() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = WelcomeViewController()
        vc.firstTimeDelegate = self
        let navCon = UINavigationController(rootViewController: vc)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(identifier: "initialClassTabBarVC") as InitialClassTabBarVC
        
        if defaults.value(forKey: "isFirstTime") != nil {
            // Not the first time. The first time should return nil and this should not run
            window?.rootViewController = mainController
            window?.makeKeyAndVisible()
        } else {
            // First time, send user to filter screen
            window?.rootViewController = navCon
            window?.makeKeyAndVisible()
        }
    }

}
extension AppDelegate: FirstTimeUseCase {
    func dismissWelcomeView(sender: WelcomeViewController) {
        // Dismiss welcome view and show filter view
        let layout = UICollectionViewFlowLayout()
        let filterVC = FilterViewController(collectionViewLayout: layout)
        filterVC.firstTimeDelegate = self
        let navCon = UINavigationController(rootViewController: filterVC)
        
        sender.dismiss(animated: false, completion: nil)
        window?.rootViewController = navCon
    }
    
    func dismissFilterView(sender: FilterViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(identifier: "initialClassTabBarVC") as InitialClassTabBarVC
        sender.dismiss(animated: false, completion: nil)
        defaults.set(false, forKey: "isFirstTime") // set this value so the right view is shown first the next time the user opens the app
        window?.rootViewController = mainController
    }

}
