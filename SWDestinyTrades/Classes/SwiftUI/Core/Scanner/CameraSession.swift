//
//  CameraSession.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import AVFoundation

/// Owns an `AVCaptureSession` and emits raw camera frames.
///
/// Capture is configured and started on a private serial executor; frames are delivered on a separate
/// sample queue so heavy work (Vision) never blocks the main thread. The session drops late
/// frames, so processing one frame at a time is enough — no manual throttling required.
actor CameraSession {

    private nonisolated let executor = DispatchSerialQueue(label: "com.swdestiny.camera.session")

    nonisolated var unownedExecutor: UnownedSerialExecutor {
        executor.asUnownedSerialExecutor()
    }

    /// AVFoundation requires the same session instance on its serial capture executor and in the
    /// main-thread preview layer, but the SDK does not declare `AVCaptureSession` as `Sendable`.
    /// No Swift mutable state is exposed through this reference; all session mutations stay here.
    nonisolated(unsafe) let captureSession = AVCaptureSession()

    private let sampleQueue = DispatchQueue(label: "com.swdestiny.camera.samples")
    private let videoOutput = AVCaptureVideoDataOutput()
    private let frameDelegate: CameraFrameDelegate
    private var isConfigured = false

    init(frameHandler: @escaping @Sendable (CVPixelBuffer) -> Void) {
        frameDelegate = CameraFrameDelegate(frameHandler: frameHandler)
    }

    // MARK: - Authorization

    nonisolated var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    nonisolated func requestAccess() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }

    // MARK: - Lifecycle

    /// Configures (once) and starts the session. Frames arrive on the background sample queue.
    func start() {
        configureIfNeeded()
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }

    func stop() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
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
        videoOutput.setSampleBufferDelegate(frameDelegate, queue: sampleQueue)

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

nonisolated private final class CameraFrameDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

    private let frameHandler: @Sendable (CVPixelBuffer) -> Void

    init(frameHandler: @escaping @Sendable (CVPixelBuffer) -> Void) {
        self.frameHandler = frameHandler
        super.init()
    }

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        frameHandler(pixelBuffer)
    }
}
