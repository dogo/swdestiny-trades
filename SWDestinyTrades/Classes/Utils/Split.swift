//
//  Split.swift
//  swdestiny-trades
//
//  Created by Diogo Autilio on 11/01/17.
//  Copyright © 2017 Diogo Autilio. All rights reserved.
//

import Foundation

enum Split {

    static func groupItems<T>(itemList: [T],
                              sections: [String],
                              sectionIdentifier: (T) -> String,
                              sortFunction: (T, T) -> Bool) -> [String: [T]] {
        var groupedItems = [String: [T]]()

        for symbol in sections {
            let filteredItems = itemList
                .filter { sectionIdentifier($0) == symbol }
                .sorted(by: sortFunction)

            groupedItems[symbol] = filteredItems
        }

        return groupedItems
    }

    static func cardsAlphabetically(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {
        let sectionIdentifier: (CardDTO) -> String = { cardDTO in
            return String(cardDTO.name[cardDTO.name.startIndex])
        }

        let sortFunction: (CardDTO, CardDTO) -> Bool = { $0.name < $1.name }

        return groupItems(itemList: cardList, sections: sections, sectionIdentifier: sectionIdentifier, sortFunction: sortFunction)
    }

    static func cardsByColor(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {
        let sectionIdentifier: (CardDTO) -> String = { $0.factionCode }
        let sortFunction: (CardDTO, CardDTO) -> Bool = { $0.name < $1.name }

        return groupItems(itemList: cardList, sections: sections, sectionIdentifier: sectionIdentifier, sortFunction: sortFunction)
    }

    static func cardsByType(cardList: [CardDTO], sections: [String]) -> [String: [CardDTO]] {
        let sectionIdentifier: (CardDTO) -> String = { $0.typeName }
        let sortFunction: (CardDTO, CardDTO) -> Bool = { $0.name < $1.name }

        return groupItems(itemList: cardList, sections: sections, sectionIdentifier: sectionIdentifier, sortFunction: sortFunction)
    }

    static func setsByAlphabetically(setList: [SetDTO], sections: [String]) -> [String: [SetDTO]] {
        let sectionIdentifier: (SetDTO) -> String = { setDTO in
            return String(setDTO.name.prefix(1))
        }

        let sortFunction: (SetDTO, SetDTO) -> Bool = { $0.name < $1.name }

        return groupItems(itemList: setList, sections: sections, sectionIdentifier: sectionIdentifier, sortFunction: sortFunction)
    }
}
