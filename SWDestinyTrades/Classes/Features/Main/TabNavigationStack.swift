//
//  TabNavigationStack.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 11/01/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct TabNavigationStack<Root: View>: View {
    @Binding var path: NavigationPath
    @ViewBuilder let root: Root

    var body: some View {
        NavigationStack(path: $path) {
            root
                .navigationDestination(for: AppDestination.self) { destination in
                    NavigationDestinationBuilder.build(destination: destination)
                }
        }
    }
}
