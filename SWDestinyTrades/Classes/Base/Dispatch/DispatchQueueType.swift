//
//  DispatchQueueType.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 28/01/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation

protocol DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void)
    func globalAsync(execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueType {

    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }

    func globalAsync(execute work: @escaping @convention(block) () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async(execute: work)
    }
}
