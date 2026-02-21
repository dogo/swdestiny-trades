import Foundation
import RealmSwift

enum SampleData {
    static let sets: [SetDTO] = {
        let awakenings = SetDTO()
        awakenings.code = "AW"
        awakenings.name = "Awakenings"

        let spiritOfRebellion = SetDTO()
        spiritOfRebellion.code = "SoR"
        spiritOfRebellion.name = "Spirit of Rebellion"

        let empireAtWar = SetDTO()
        empireAtWar.code = "EaW"
        empireAtWar.name = "Empire at War"

        return [awakenings, spiritOfRebellion, empireAtWar]
    }()

    static let cards: [CardDTO] = [
        createLukeSkywalker(),
        createDarthVader(),
        createLightsaber(),
        createForcePush(),
        createRey()
    ]

    static let decks: [DeckDTO] = {
        let heroicDeck = DeckDTO()
        heroicDeck.name = "Heroic Rebels"
        heroicDeck.list.append(objectsIn: [cards[0], cards[2], cards[3]])

        let villainDeck = DeckDTO()
        villainDeck.name = "Dark Side Power"
        villainDeck.list.append(objectsIn: [cards[1], cards[2]])

        let reyDeck = DeckDTO()
        reyDeck.name = "Rey's Journey"
        reyDeck.list.append(objectsIn: [cards[4], cards[2], cards[3]])

        return [heroicDeck, villainDeck, reyDeck]
    }()

    static let people: [PersonDTO] = {
        let john = PersonDTO()
        john.name = "John"
        john.lastName = "Smith"
        john.lentMe.append(objectsIn: [cards[0], cards[2]])

        let sarah = PersonDTO()
        sarah.name = "Sarah"
        sarah.lastName = "Connor"
        sarah.borrowed.append(objectsIn: [cards[1]])

        let mike = PersonDTO()
        mike.name = "Mike"
        mike.lastName = "Johnson"
        mike.lentMe.append(objectsIn: [cards[3]])
        mike.borrowed.append(objectsIn: [cards[4]])

        return [john, sarah, mike]
    }()

    private static func createLukeSkywalker() -> CardDTO {
        let card = CardDTO()
        card.code = "01001"
        card.name = "Luke Skywalker"
        card.subtitle = "Unlikely Hero"
        card.setCode = "AW"
        card.setName = "Awakenings"
        card.typeCode = "character"
        card.typeName = "Character"
        card.factionCode = "blue"
        card.factionName = "Hero"
        card.affiliationCode = "rebel"
        card.affiliationName = "Rebel"
        card.rarityCode = "R"
        card.rarityName = "Rare"
        card.position = 1
        card.cost = 0
        card.health = 10
        card.points = "10/13"
        card.text = "After you activate this character, you may give a shield to another character."
        card.deckLimit = 1
        card.isUnique = true
        card.hasDie = true
        card.imageUrl = "https://swdestinydb.com/bundles/cards/01001.jpg"
        card.externalUrl = "https://swdestinydb.com/card/01001"
        card.illustrator = "Darren Tan"
        card.label = "AW #1"
        return card
    }

    private static func createDarthVader() -> CardDTO {
        let card = CardDTO()
        card.code = "01010"
        card.name = "Darth Vader"
        card.subtitle = "Sith Lord"
        card.setCode = "AW"
        card.setName = "Awakenings"
        card.typeCode = "character"
        card.typeName = "Character"
        card.factionCode = "red"
        card.factionName = "Villain"
        card.affiliationCode = "sith"
        card.affiliationName = "Sith"
        card.rarityCode = "R"
        card.rarityName = "Rare"
        card.position = 10
        card.cost = 0
        card.health = 12
        card.points = "15/20"
        card.text = "After you activate this character, deal 1 damage to a character."
        card.deckLimit = 1
        card.isUnique = true
        card.hasDie = true
        card.imageUrl = "https://swdestinydb.com/bundles/cards/01010.jpg"
        card.externalUrl = "https://swdestinydb.com/card/01010"
        card.illustrator = "Darren Tan"
        card.label = "AW #10"
        return card
    }

    private static func createLightsaber() -> CardDTO {
        let card = CardDTO()
        card.code = "01040"
        card.name = "Lightsaber"
        card.subtitle = ""
        card.setCode = "AW"
        card.setName = "Awakenings"
        card.typeCode = "upgrade"
        card.typeName = "Upgrade"
        card.factionCode = "blue"
        card.factionName = "Blue"
        card.affiliationCode = ""
        card.affiliationName = ""
        card.rarityCode = "R"
        card.rarityName = "Rare"
        card.position = 40
        card.cost = 3
        card.health = 0
        card.points = ""
        card.text = "Redeploy. After you play this upgrade, you may reroll any number of your dice."
        card.deckLimit = 2
        card.isUnique = false
        card.hasDie = true
        card.imageUrl = "https://swdestinydb.com/bundles/cards/01040.jpg"
        card.externalUrl = "https://swdestinydb.com/card/01040"
        card.illustrator = "Cristi Balanescu"
        card.label = "AW #40"
        return card
    }

    private static func createForcePush() -> CardDTO {
        let card = CardDTO()
        card.code = "01050"
        card.name = "Force Push"
        card.subtitle = ""
        card.setCode = "AW"
        card.setName = "Awakenings"
        card.typeCode = "event"
        card.typeName = "Event"
        card.factionCode = "blue"
        card.factionName = "Blue"
        card.affiliationCode = ""
        card.affiliationName = ""
        card.rarityCode = "C"
        card.rarityName = "Common"
        card.position = 50
        card.cost = 2
        card.health = 0
        card.points = ""
        card.text = "Remove a die showing melee damage."
        card.deckLimit = 2
        card.isUnique = false
        card.hasDie = false
        card.imageUrl = "https://swdestinydb.com/bundles/cards/01050.jpg"
        card.externalUrl = "https://swdestinydb.com/card/01050"
        card.illustrator = "Cristi Balanescu"
        card.label = "AW #50"
        return card
    }

    private static func createRey() -> CardDTO {
        let card = CardDTO()
        card.code = "02001"
        card.name = "Rey"
        card.subtitle = "Finding the Ways"
        card.setCode = "SoR"
        card.setName = "Spirit of Rebellion"
        card.typeCode = "character"
        card.typeName = "Character"
        card.factionCode = "blue"
        card.factionName = "Hero"
        card.affiliationCode = "force"
        card.affiliationName = "Force"
        card.rarityCode = "L"
        card.rarityName = "Legendary"
        card.position = 1
        card.cost = 0
        card.health = 11
        card.points = "12/16"
        card.text = "After you activate this character, you may resolve one of her dice, increasing its value by 1."
        card.deckLimit = 1
        card.isUnique = true
        card.hasDie = true
        card.imageUrl = "https://swdestinydb.com/bundles/cards/02001.jpg"
        card.externalUrl = "https://swdestinydb.com/card/02001"
        card.illustrator = "Darren Tan"
        card.label = "SoR #1"
        return card
    }
}
