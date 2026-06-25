//
//  CardEmbeddingIndex.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 25/06/26.
//  Copyright © 2026 Diogo Autilio. All rights reserved.
//

import Foundation

struct CardEmbeddingEntry {
    let code: String
    let vector: [Float]
}

struct CardMatch: Equatable {
    let code: String
    let score: Float
}

/// In-memory embedding index with linear cosine nearest-neighbor search. Vectors are L2-normalized
/// once at load, so a query is a dot product per entry.
///
/// Binary format (`.swdx`, little-endian), shared with the Python index builder:
/// `magic("SWDX") | version:UInt32 | dim:UInt32 | count:UInt32` then per entry
/// `codeLen:UInt16 | codeUTF8 | dim×Float32`.
final class CardEmbeddingIndex {

    private static let magic: [UInt8] = Array("SWDX".utf8)

    let dimension: Int
    private let codes: [String]
    private let normalized: [[Float]]

    var count: Int { codes.count }

    init(entries: [CardEmbeddingEntry]) {
        dimension = entries.first?.vector.count ?? 0
        codes = entries.map(\.code)
        normalized = entries.map { Self.normalize($0.vector) }
    }

    /// Best score per entry across multiple query vectors (used for rotation test-time augmentation).
    func nearest(toAny queries: [[Float]], limit: Int = 5) -> [CardMatch] {
        guard !codes.isEmpty else { return [] }
        let normalizedQueries = queries.filter { $0.count == dimension }.map { Self.normalize($0) }
        guard !normalizedQueries.isEmpty else { return [] }

        var matches: [CardMatch] = []
        matches.reserveCapacity(codes.count)
        for index in codes.indices {
            var best: Float = -1
            for query in normalizedQueries {
                best = Swift.max(best, Self.dot(query, normalized[index]))
            }
            matches.append(CardMatch(code: codes[index], score: best))
        }
        return Array(matches.sorted { $0.score > $1.score }.prefix(limit))
    }

    // MARK: - Math

    private static func normalize(_ vector: [Float]) -> [Float] {
        var sum: Float = 0
        for value in vector { sum += value * value }
        let norm = sum.squareRoot()
        guard norm.isFinite, norm > 0 else { return [Float](repeating: 0, count: vector.count) }
        return vector.map { $0 / norm }
    }

    private static func dot(_ lhs: [Float], _ rhs: [Float]) -> Float {
        var result: Float = 0
        for index in lhs.indices { result += lhs[index] * rhs[index] }
        return result
    }

    // MARK: - Loading

    static func load(from url: URL) throws -> [CardEmbeddingEntry] {
        let data = try Data(contentsOf: url)
        var cursor = 0

        func read(_ count: Int) throws -> Data {
            guard cursor + count <= data.count else { throw ScannerError.invalidIndexData }
            defer { cursor += count }
            return data.subdata(in: cursor..<(cursor + count))
        }

        guard try Array(read(4)) == magic else { throw ScannerError.invalidIndexData }
        _ = try read(4) // version
        let dim = Int(try read(4).readLittleEndianUInt32())
        let count = Int(try read(4).readLittleEndianUInt32())
        guard dim > 0 else { throw ScannerError.invalidIndexData }

        var entries: [CardEmbeddingEntry] = []
        entries.reserveCapacity(count)
        for _ in 0..<count {
            let codeLen = Int(try read(2).readLittleEndianUInt16())
            let code = String(decoding: try read(codeLen), as: UTF8.self)
            let floatBytes = try read(dim * 4)
            let vector: [Float] = floatBytes.withUnsafeBytes { buffer in
                buffer.bindMemory(to: UInt32.self).map { Float(bitPattern: UInt32(littleEndian: $0)) }
            }
            entries.append(CardEmbeddingEntry(code: code, vector: vector))
        }
        return entries
    }
}

enum ScannerError: Error {
    case embeddingFailed
    case invalidIndexData
}

private extension Data {
    func readLittleEndianUInt16() -> UInt16 {
        withUnsafeBytes { UInt16(littleEndian: $0.loadUnaligned(as: UInt16.self)) }
    }

    func readLittleEndianUInt32() -> UInt32 {
        withUnsafeBytes { UInt32(littleEndian: $0.loadUnaligned(as: UInt32.self)) }
    }
}
