//
//  AppDelegate.swift
//  SwiftReactNative
//
//  Created by Martin on 04.07.24.
//

import Foundation

import UIKit
import React
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    // MARK: ReactNative
    let bridge = RCTBridge(delegate: self, launchOptions: launchOptions)!
    let rootView = RCTRootView(bridge: bridge, moduleName: "SwiftReactNative", initialProperties: nil)
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let rootViewController = UIViewController()
    
    rootViewController.view = rootView
    
    self.window!.rootViewController = rootViewController;
    self.window!.makeKeyAndVisible()
    
    return true
  }
}

// MARK: RCTBridgeDelegate
extension AppDelegate: RCTBridgeDelegate {
    func sourceURL(for bridge: RCTBridge) -> URL? {
      // DEBUG requires SWIFT_ACTIVE_COMPILATION_CONDITIONS to contain DEBUG in a line in your target/build settings
      #if DEBUG
        NSLog("use metro server url - change schema build configuration to switch to release mode")
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
      #else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
      #endif
    }
}
  
