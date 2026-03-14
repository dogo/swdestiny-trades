//
//  SnapshotableTestCase.swift
//  SWDestinyTradesTests
//
//  Created by Diogo Autilio on 11/12/23.
//  Copyright © 2023 Diogo Autilio. All rights reserved.
//

import Foundation
import iOSSnapshotTestCase

/// Enum to represent different test modes
enum SnapshotTestMode {
    case record
    case validate
}

class XCSnapshotableTestCase: FBSnapshotTestCase {

    /// Captures and validates a snapshot of the specified view or layer.
    /// - Parameters:
    ///   - instance: The view or layer to snapshot. The object must conform to the `Snapshotable` protocol.
    ///   - named: An optional name for the snapshot, used to identify the reference image. If `nil`, a default name is used.
    ///   - testMode: The mode for the snapshot test. Use `.validate` to compare against an existing snapshot or `.record` to create a new reference image.
    ///   - perPixelTolerance: The percentage by which a pixel's R, G, B, and A components can differ from the reference image and still be considered identical. The default is `0.02`.
    ///   - overallTolerance: The percentage of pixels that can differ from the reference image and still be considered identical. The default is `0`.
    ///   - file: The file path of the test, used to determine the reference image and diff directories. The default is the current file path.
    /// - Returns: `true` if the comparison or saving of the reference image succeeds; otherwise, `false`.
    func snapshot(_ instance: Snapshotable,
                  named: String? = nil,
                  testMode: SnapshotTestMode = .validate,
                  perPixelTolerance: CGFloat = 0.02,
                  overallTolerance: CGFloat = 0,
                  file: StaticString = #file,
                  line: UInt = #line) -> Bool {
        guard let snapshotObject = instance.snapshotObject else {
            fatalError("Failed unwrapping Snapshot Object")
        }

        let sanitizedName = sanitizedTestName(named)
        let result = FBSnapshotTestCase.validateSnapshot(snapshotObject,
                                                         snapshot: sanitizedName,
                                                         record: testMode == .record,
                                                         referenceDirectory: getDefaultReferenceDirectory(file),
                                                         imageDiffDirectory: getDefaultDiffDirectory(file),
                                                         perPixelTolerance: perPixelTolerance,
                                                         overallTolerance: overallTolerance,
                                                         filename: file)

        if testMode == .record {
            XCTFail("Snapshot recorded — change testMode to .validate before committing.", file: file, line: line)
        }

        return result
    }

    private func getDefaultReferenceDirectory(_ sourceFileName: StaticString) -> String {
        if let environmentReference = ProcessInfo.processInfo.environment["FB_REFERENCE_IMAGE_DIR"] {
            return environmentReference
        }

        return getTestsRootFolder(sourceFileName) + "/ReferenceImages"
    }

    private func getDefaultDiffDirectory(_ sourceFileName: StaticString) -> String {
        if let environmentReference = ProcessInfo.processInfo.environment["IMAGE_DIFF_DIR"] {
            return environmentReference
        }
        return getTestsRootFolder(sourceFileName) + "/FailureDiffs"
    }

    /// Search the test file's path to find the first folder with a test suffix,
    /// then append "/ReferenceImages" or "FailureDiffs" and use that.
    private func getTestsRootFolder(_ sourceFileName: StaticString) -> String {
        let fileName = String(describing: sourceFileName)

        // Find the directory in the path that ends with a test or specs suffix.
        guard let testPath = fileName.components(separatedBy: "/").first(where: { component in
            ["tests", "specs"].contains {
                component.lowercased().hasSuffix($0)
            }
        }) else {
            fatalError("Could not infer the unit test root folder")
        }

        // Recombine the path components and append our own image directory.
        guard let currentIndex = fileName.components(separatedBy: "/").firstIndex(of: testPath) else {
            fatalError("Unexpected error while extracting the test path.")
        }

        let folderPathComponents = Array(fileName.components(separatedBy: "/")[0 ... currentIndex])
        return folderPathComponents.joined(separator: "/")
    }

    private func sanitizedTestName(_ snapshotName: String?) -> String {
        var filename = snapshotName ?? name
        filename = filename.replacingOccurrences(of: "root example group, ", with: "")
        let characterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        let components = filename.components(separatedBy: characterSet.inverted)
        return components.joined(separator: "_")
    }
}
