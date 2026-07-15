//
//  CameraPreviewView.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AVFoundation
import SwiftUI

/// SwiftUI bridge for a live `AVCaptureVideoPreviewLayer`.
struct CameraPreviewView: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {}

    final class PreviewView: UIView {
        // `static` is not valid here — UIKit requires overriding the `class var`.
        // swiftlint:disable:next static_over_final_class
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            // swiftlint:disable:next force_cast
            layer as! AVCaptureVideoPreviewLayer
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            if let connection = videoPreviewLayer.connection, connection.isVideoRotationAngleSupported(90) {
                connection.videoRotationAngle = 90 // portrait
            }
        }
    }
}
