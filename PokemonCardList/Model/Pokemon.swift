//
//  Pokemon.swift
//  PokemonCardList
//
//  Created by Roberts Kursitis on 19/08/2022.
//

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let data: [Datum]
    let page, pageSize, count, totalCount: Int

}

// MARK: - Datum
struct Datum: Codable {
    let id, name: String
    let supertype: Supertype
    let subtypes: [Subtype]
    let level: String?
    let hp: String
    let types: [RetreatCost]
    let evolvesTo: [String]?
    let attacks: [Attack]?
    let weaknesses: [Resistance]?
    let retreatCost: [RetreatCost]?
    let convertedRetreatCost: Int?
    let datumSet: Set
    let number, artist: String
    let rarity: Rarity
    let flavorText: String?
    let nationalPokedexNumbers: [Int]
    let legalities: DatumLegalities
    let images: DatumImages
    let tcgplayer: Tcgplayer
    let cardmarket: Cardmarket
    let evolvesFrom: String?
    let abilities: [Ability]?
    let resistances: [Resistance]?

    enum CodingKeys: String, CodingKey {
        case id, name, supertype, subtypes, level, hp, types, evolvesTo, attacks, weaknesses, retreatCost, convertedRetreatCost
        case datumSet = "set"
        case number, artist, rarity, flavorText, nationalPokedexNumbers, legalities, images, tcgplayer, cardmarket, evolvesFrom, abilities, resistances
    }
}

// MARK: - Ability
struct Ability: Codable {
    let name, text: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case pokémonPower = "Pokémon Power"
}

// MARK: - Attack
struct Attack: Codable {
    let name: String
    let cost: [RetreatCost]
    let convertedEnergyCost: Int
    let damage, text: String
}

enum RetreatCost: String, Codable {
    case colorless = "Colorless"
    case fighting = "Fighting"
    case fire = "Fire"
    case grass = "Grass"
    case lightning = "Lightning"
    case psychic = "Psychic"
    case water = "Water"
}

// MARK: - Cardmarket
struct Cardmarket: Codable {
    let url: String
    let updatedAt: CardmarketUpdatedAt
    let prices: [String: Double]
}

enum CardmarketUpdatedAt: String, Codable {
    case the20220819 = "2022/08/19"
}

// MARK: - Set
struct Set: Codable {
    let id: ID
    let name, series: Name
    let printedTotal, total: Int
    let legalities: SetLegalities
    let ptcgoCode: PtcgoCode
    let releaseDate: ReleaseDate
    let updatedAt: SetUpdatedAt
    let images: SetImages
}

enum ID: String, Codable {
    case base1 = "base1"
    case base2 = "base2"
    case base3 = "base3"
    case basep = "basep"
}

// MARK: - SetImages
struct SetImages: Codable {
    let symbol, logo: String
}

// MARK: - SetLegalities
struct SetLegalities: Codable {
    let unlimited: Expanded
}

enum Expanded: String, Codable {
    case legal = "Legal"
}

enum Name: String, Codable {
    case base = "Base"
    case fossil = "Fossil"
    case jungle = "Jungle"
    case wizardsBlackStarPromos = "Wizards Black Star Promos"
}

enum PtcgoCode: String, Codable {
    case bs = "BS"
    case fo = "FO"
    case ju = "JU"
    case pr = "PR"
}

enum ReleaseDate: String, Codable {
    case the19990109 = "1999/01/09"
    case the19990616 = "1999/06/16"
    case the19990701 = "1999/07/01"
    case the19991010 = "1999/10/10"
}

enum SetUpdatedAt: String, Codable {
    case the20200814093500 = "2020/08/14 09:35:00"
}

// MARK: - DatumImages
struct DatumImages: Codable {
    let small, large: String
}

// MARK: - DatumLegalities
struct DatumLegalities: Codable {
    let unlimited: Expanded
    let expanded: Expanded?
}

enum Rarity: String, Codable {
    case common = "Common"
    case promo = "Promo"
    case rare = "Rare"
    case rareHolo = "Rare Holo"
    case uncommon = "Uncommon"
}

// MARK: - Resistance
struct Resistance: Codable {
    let type: RetreatCost
    let value: String
}

enum Subtype: String, Codable {
    case basic = "Basic"
    case stage1 = "Stage 1"
    case stage2 = "Stage 2"
}

enum Supertype: String, Codable {
    case pokémon = "Pokémon"
}

// MARK: - Tcgplayer
struct Tcgplayer: Codable {
    let url: String
    let updatedAt: CardmarketUpdatedAt
    let prices: Prices
}

// MARK: - Prices
struct Prices: Codable {
    let normal, holofoil, the1StEdition, unlimited: The1_StEdition?
    let the1StEditionHolofoil, unlimitedHolofoil: The1_StEdition?

    enum CodingKeys: String, CodingKey {
        case normal, holofoil
        case the1StEdition = "1stEdition"
        case unlimited
        case the1StEditionHolofoil = "1stEditionHolofoil"
        case unlimitedHolofoil
    }
}

// MARK: - The1_StEdition
struct The1_StEdition: Codable {
    let low, mid, high, market: Double
    let directLow: Double?
}
