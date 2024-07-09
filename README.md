# Info

this project shows the needed steps to migrate the inital [react-native](https://github.com/facebook/react-native) setup to pure Swift without the usage of [expo](https://github.com/expo).

# problem

When creating a react-native project, it will create an Objective-C application delegate. After just replacing the Objective-C version with the Swift version, the run command will result in a error "No bundle URL present".
This may have 2 reasons:
1. the code for getting the URL changed through the years - solved by providing this repository with the swift file
2. mismatch between running the cli command and the build setting. The react-native template doesn't set the `DEBUG` flag correctly. - solved by providing the setup steps here 

# requirements

xcode version: see `XCODE_VERSION.md`  
react native verison: see `package.json`

# Setup

- `npx @react-native-community/cli@latest init SwiftReactNative`
- open XCode
- open `ios/SwiftReactNative.xcworkspace`
- remove `main.m`, `AppDelegate.h` and `AppDelegate.mm`
- select File / New / File...
- select `Swift File`
- select folder `ios/SwiftReactNative` and name `AppDelegate`
- check "create bridge file" (or how it was spelled)
- add to `SwiftReactNative-Bridge-Header.h`
  ```c++
   #import <React/RCTBridgeModule.h>
   #import <React/RCTBridge.h>
   #import <React/RCTEventDispatcher.h>
   #import <React/RCTRootView.h>
   #import <React/RCTUtils.h>
   #import <React/RCTConvert.h>
  ```
- add to `AppDelegate.swift`
  ```swift
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
  ```
- select project `SwiftReactNative` in left File navigator
- select target `SwiftReactNative`
- select tab `Build Settings`
- search for `SWIFT_ACTIVE_COMPILATION_CONDITIONS`
- extend the selection and add `DEBUG` on the right for `Debug` on the left
