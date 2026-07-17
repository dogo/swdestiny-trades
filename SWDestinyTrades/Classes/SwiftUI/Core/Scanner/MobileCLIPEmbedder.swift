//
//  MobileCLIPEmbedder.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import CoreGraphics
import CoreML
import Synchronization
import Vision

/// Embeds a card crop with the bundled, fine-tuned MobileCLIP image encoder (Core ML, FP32).
///
/// The encoder was fine-tuned so phone photos match the catalog scans (see Tooling/ml). The model
/// bakes CLIP normalization; cosine normalization happens in `CardEmbeddingIndex`.
nonisolated final class MobileCLIPEmbedder: Sendable {

    static let bundledModelName = "MobileCLIPImage"

    private let model: Mutex<VNCoreMLModel>

    init(modelURL: URL) throws {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .all
        let mlModel = try MLModel(contentsOf: modelURL, configuration: configuration)
        model = Mutex(try VNCoreMLModel(for: mlModel))
    }

    static func bundled(name: String = bundledModelName, in bundle: Bundle = .main) -> MobileCLIPEmbedder? {
        if let url = bundle.url(forResource: name, withExtension: "mlmodelc") {
            return try? MobileCLIPEmbedder(modelURL: url)
        }
        if let packageURL = bundle.url(forResource: name, withExtension: "mlpackage"),
           let compiledURL = try? MLModel.compileModel(at: packageURL) {
            return try? MobileCLIPEmbedder(modelURL: compiledURL)
        }
        return nil
    }

    /// Embeds the image at the given orientation (used to try the 4 card rotations). CPU-bound.
    func embed(_ image: CGImage, orientation: CGImagePropertyOrientation) throws -> [Float] {
        try model.withLock { model in
            let request = VNCoreMLRequest(model: model)
            request.imageCropAndScaleOption = .scaleFill

            let handler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
            try handler.perform([request])

            guard let observation = request.results?.first as? VNCoreMLFeatureValueObservation,
                  let multiArray = observation.featureValue.multiArrayValue else {
                throw ScannerError.embeddingFailed
            }
            return (0 ..< multiArray.count).map { multiArray[$0].floatValue }
        }
    }
}
