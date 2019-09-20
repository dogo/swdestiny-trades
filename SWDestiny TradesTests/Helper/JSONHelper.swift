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

    public static func loadJSON<Element: Decodable>(withFile fileName: String) -> Element? {
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

    public static func loadJSONData(withFile fileName: String) -> Any? {
        var jsonData: Any?
        if let url = Bundle(for: BundleTestClass.self).url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return jsonData
    }
}
