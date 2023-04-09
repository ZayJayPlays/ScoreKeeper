//
//  PlayerScore.swift
//  Score Counter
//
//  Created by Zane Jones on 3/23/23.
//

import Foundation
import UIKit

struct PlayerScore: Codable {
    var name: String?
    var image: Data?
    var score: Int?
    
    init(name: String, image: Data?, score: Int) {
        self.name = name
        self.image = image
        self.score = score
        
        
    }
    static func saveToFile(player: [PlayerScore]) {
        let encodedPlayers = try? propertyListEncoder.encode(player)
        try? encodedPlayers?.write(to: archiveURL)
    }
    
    static func loadFromFile() -> [PlayerScore] {
        var output = [PlayerScore]()
        if let retrievedPlayerData = try? Data(contentsOf: archiveURL),
           let decodedPlayers = try? propertyListDecoder.decode([PlayerScore].self, from: retrievedPlayerData) {
            output = decodedPlayers
        }
        return output
    }
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("players").appendingPathExtension("plist")
    
}

let propertyListEncoder = PropertyListEncoder()
let propertyListDecoder = PropertyListDecoder()
