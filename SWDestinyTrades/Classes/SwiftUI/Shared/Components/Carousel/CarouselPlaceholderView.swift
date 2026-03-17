//
//  CarouselPlaceholderView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 2/01/26.
//  Copyright © 2025 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct CarouselPlaceholderView: View {
    let placeholder: UIImage?

    var body: some View {
        if let placeholder {
            Image(uiImage: placeholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Color(.systemGray6)
        }
    }
}
