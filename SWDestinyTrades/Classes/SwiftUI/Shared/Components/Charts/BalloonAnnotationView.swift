//
//  BalloonAnnotationView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 24/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import SwiftUI

struct BalloonAnnotationView: View {
    let text: String

    var body: some View {
        VStack(spacing: 0.0) {
            Text(text)
                .font(.system(size: 10.0))
                .foregroundStyle(.white)
                .padding(.horizontal, 8.0)
                .padding(.vertical, 6.0)
                .background(Color(.systemGray), in: RoundedRectangle(cornerRadius: 6.0))

            BalloonArrow()
                .fill(Color(.systemGray))
                .frame(width: 14.0, height: 8.0)
        }
    }
}

private struct BalloonArrow: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
