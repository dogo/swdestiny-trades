//
//  main.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 26/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit

let kIsRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass = kIsRunningTests ? nil : NSStringFromClass(AppDelegate.self)
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, args, nil, appDelegateClass)
