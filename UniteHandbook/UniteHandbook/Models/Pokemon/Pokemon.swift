//
//  Pokemon.swift
//  UniteHandbook
//
//  Created by Jayme Rutkoski on 2/9/23.
//

import Foundation

public class Pokemon : Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case attackStyle = "AttackStyle"
        case role = "Role"
        case style = "Style"
        case difficulty = "Difficulty"
        case ability = "Ability"
        case moves = "Moves"
        case stats = "Stats"
    }
    
    public var name: String = ""
    public var attackStyle: String = ""
    public var role: String = ""
    public var style: String = ""
    public var difficulty: String = ""
    public var ability: Ability = Ability()
    public var moves: [Move] = [Move]()
    public var stats: [StatDetails] = [StatDetails]()
    
    public init() { }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.attackStyle = try container.decode(String.self, forKey: .attackStyle)
        self.role = try container.decode(String.self, forKey: .role)
        self.style = try container.decode(String.self, forKey: .style)
        self.difficulty = try container.decode(String.self, forKey: .difficulty)
        self.ability = try container.decode(Ability.self, forKey: .ability)
        self.moves = try container.decode([Move].self, forKey: .moves)
        self.stats = try container.decode([StatDetails].self, forKey: .stats)
    }
    
    static func loadJson(filename fileName: String) -> Pokemon {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Pokemon.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return Pokemon()
    }
}
