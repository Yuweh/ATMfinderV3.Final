//
//  AppDelegate.swift
//  ATMfinderV3
//
//  Created by Francis Jemuel Bergonia on 24/12/2017.
//  Copyright © 2017 Francis Jemuel Bergonia. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

    //let kMapsAPIKey =

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //key: "AIzaSyDDhf8kMmTZTxQ2SP-wsTXGNyEuobrOKw0"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Configure API key
        GMSPlacesClient.provideAPIKey("AIzaSyAdQsDZr6sNfbPBjvb6Mt8CzQSVk00FTLo")
        GMSServices.provideAPIKey("AIzaSyAdQsDZr6sNfbPBjvb6Mt8CzQSVk00FTLo")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

