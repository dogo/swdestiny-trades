//
//  JSONHelper.swift
//  SWDestiny-TradesTests
//
//  Created by Diogo Autilio on 19/09/19.
//  Copyright © 2019 Diogo Autilio. All rights reserved.
//

import Foundation

private class BundleTestClass {}

enum JSONHelper {

    static func loadJSON<Element: Decodable>(withFile fileName: String) -> Element? {
        guard !fileName.isEmpty else {
            debugPrint("File name is empty")
            return nil
        }

        var jsonData: Element?
        if let url = Bundle(for: BundleTestClass.self).url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                jsonData = try decoder.decode(Element.self, from: data)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return jsonData
    }

    static func loadJSONData(withFile fileName: String) -> Data? {
        guard !fileName.isEmpty else {
            debugPrint("File name is empty")
            return nil
        }

        var data: Data?
        if let url = Bundle(for: BundleTestClass.self).url(forResource: fileName, withExtension: "json") {
            do {
                data = try Data(contentsOf: url)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return data
    }
}
