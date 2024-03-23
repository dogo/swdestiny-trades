//
//  PopoverMenuManager.swift
//  SWDestinyTrades
//
//  Created by Diogo Autilio on 23/03/24.
//  Copyright © 2024 Diogo Autilio. All rights reserved.
//

import Foundation
import FTPopOverMenu
import UIKit

protocol PopoverMenuManagerType {
    func showPopoverMenu(forEvent event: UIEvent, with menuArray: [String], done: ((NSInteger) -> Void)?, cancel: (() -> Void)?)
}

final class PopoverMenuManager: PopoverMenuManagerType {

    // Configures the appearance of the popover menu
    private func appearance() -> FTConfiguration {
        let config = FTConfiguration()
        config.backgoundTintColor = ColorPalette.appTheme
        config.borderColor = ColorPalette.appTheme
        config.menuSeparatorColor = .lightGray
        config.textColor = .white
        config.textAlignment = .center
        return config
    }

    // Displays the popover menu for the given event
    func showPopoverMenu(forEvent event: UIEvent,
                         with menuArray: [String],
                         done: ((NSInteger) -> Void)?,
                         cancel: (() -> Void)? = nil) {
        FTPopOverMenu.showForEvent(event: event,
                                   with: menuArray,
                                   config: appearance(),
                                   done: done,
                                   cancel: cancel)
    }
}
