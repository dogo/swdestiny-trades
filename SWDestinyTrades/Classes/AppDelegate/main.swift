//
//  main.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

let kIsRunningTests = NSClassFromString("XCTestCase") != nil
let kAppDelegateClass = kIsRunningTests ? nil : NSStringFromClass(AppDelegate.self)
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(UIApplication.self), kAppDelegateClass)
