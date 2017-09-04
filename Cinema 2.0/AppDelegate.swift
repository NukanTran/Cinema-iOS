//
//  AppDelegate.swift
//  Cinema 2.0
//
//  Created by Trần Hoàng Lâm on 3/2/17.
//  Copyright © 2017 Trần Hoàng Lâm. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics

import Google
import GoogleMaps
import GoogleSignIn

import FBSDKCoreKit

import IQKeyboardManagerSwift

let appDelegate:AppDelegate = {
    return UIApplication.shared.delegate as! AppDelegate
}()

let tabBar:TabBarController = {
    return appDelegate.tabBar!
}()

let alert = SweetAlert()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager:CLLocationManager?
    var tabBar:TabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //setup viewcontroller
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if ManagerUser.idLocation.isEmpty{
            self.window?.rootViewController = LocationController()
        }else{
            tabBar = TabBarController()
            self.window?.rootViewController = tabBar
        }
        self.window?.makeKeyAndVisible()
        
        //config fabric
        Fabric.with([Crashlytics.self])
        
        //config facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //config ggmap
        GMSServices.provideAPIKey(AppConstants.APIKey.gMapAPIKey)
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
        //config google sigin
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().delegate = self
        
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                _ = alert.showAlert("Thông Báo", subTitle: "Vui lòng cho phép truy cập vị trí để tìm đường!", style: .warning)
//                print("No access location")
//                break
//            default:
//                break
//            }
//        } else {
//            _ = alert.showAlert("Thông Báo", subTitle: "Vui lòng cho phép truy cập vị trí để tìm đường!", style: .warning)
//            print("Location services are not enabled")
//        }
        
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let facebook = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        let google = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        return facebook && google
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.window?.rootViewController?.presentedViewController is WebViewTrailer{
            return .allButUpsideDown
        }
        return .portrait
    }

}

extension AppDelegate: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ManagerUser.myLocation = locations.last
        self.locationManager?.stopUpdatingLocation()
        self.locationManager = nil
    }
}

extension AppDelegate: GIDSignInDelegate {
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print( "didSignInFor")
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print( "didSignInForUser")
    }
    
    func sign_didDisconnectWithIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: Error!) {
        print( "didDisconnectWithUser")
    }
}

