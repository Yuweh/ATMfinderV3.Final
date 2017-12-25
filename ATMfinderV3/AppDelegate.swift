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

internal let GoogleAPIkey = "AIzaSyDDhf8kMmTZTxQ2SP-wsTXGNyEuobrOKw0"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //ket: "AIzaSyDDhf8kMmTZTxQ2SP-wsTXGNyEuobrOKw0"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if GoogleAPIkey.isEmpty {
            let bundleId = Bundle.main.bundleIdentifier!
            let msg = "Configure API keys inside Appdelegate.swift for your  bundle `\(bundleId)`, " +
            "see README.GooglePlacesClone for more information"
            print(msg)
        }
        
        //Configure API key
        GMSPlacesClient.provideAPIKey(GoogleAPIkey)
        GMSServices.provideAPIKey(GoogleAPIkey)
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

