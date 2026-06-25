//
//  CameraSession.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AVFoundation

/// Thin wrapper around `AVCaptureSession` that emits raw camera frames.
///
/// Capture is configured and started on a private queue; frames are delivered on a separate
/// sample queue so heavy work (Vision) never blocks the main thread. The session drops late
/// frames, so processing one frame at a time is enough — no manual throttling required.
final class CameraSession: NSObject {

    let captureSession = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "com.swdestiny.camera.session")
    private let sampleQueue = DispatchQueue(label: "com.swdestiny.camera.samples")
    private let videoOutput = AVCaptureVideoDataOutput()

    private var isConfigured = false
    private var frameHandler: ((CVPixelBuffer) -> Void)?

    // MARK: - Authorization

    var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    func requestAccess() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }

    // MARK: - Lifecycle

    /// Configures (once) and starts the session. `frameHandler` is called on a background queue.
    func start(frameHandler: @escaping (CVPixelBuffer) -> Void) {
        self.frameHandler = frameHandler
        sessionQueue.async { [weak self] in
            guard let self else { return }
            configureIfNeeded()
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
        }
    }

    func stop() {
        sessionQueue.async { [weak self] in
            guard let self, captureSession.isRunning else { return }
            captureSession.stopRunning()
        }
    }

    // MARK: - Configuration

    private func configureIfNeeded() {
        guard !isConfigured else { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.addInput(input)

        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.setSampleBufferDelegate(self, queue: sampleQueue)

        guard captureSession.canAddOutput(videoOutput) else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.addOutput(videoOutput)

        if let connection = videoOutput.connection(with: .video), connection.isVideoRotationAngleSupported(90) {
            connection.videoRotationAngle = 90 // portrait
        }

        captureSession.commitConfiguration()
        isConfigured = true
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraSession: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        frameHandler?(pixelBuffer)
    }
}
