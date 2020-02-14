//
//  Character.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 05/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation
import UIKit

class Character: Equatable {
    
    
    var id: Int
    var name: String
    var type: CharacterType
    var assetName: String
    
    var powerstats: CharacterPowerstats
    var fullName: String
    var height: Int
    var weight: Int
    
    var baseLocation: String
    
    var occupation: String?
    
    internal init(id: Int, name: String, type: CharacterType, assetName: String, powerstats: CharacterPowerstats, fullName: String = "Unknown", height: Int, weight: Int, baseLocation: String, occupation: String?) {
        self.id = id
        self.name = name
        self.type = type
        self.assetName = assetName
        self.powerstats = powerstats
        self.fullName = fullName
        self.height = height
        self.weight = weight
        self.baseLocation = baseLocation
        self.occupation = occupation
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
    
    func attributedString(withFont font: UIFont) -> NSAttributedString {
        switch name {
        case "Bane":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.lightGray
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Batgirl":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.systemYellow
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Batman":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.yellow
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Catwoman":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.systemRed
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Harley Quinn":
            let attributesHarley: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.red
            ]
            let harleyPart = NSMutableAttributedString(string: "Harley ", attributes: attributesHarley)
            
            let attributesQuinn: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.black
            ]
            let quinnPart = NSMutableAttributedString(string: "Quinn", attributes: attributesQuinn)
            
            harleyPart.append(quinnPart)
            return harleyPart
            
        case "Joker":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.green,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.purple
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Nightwing":
            let attributesNight: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.blue
            ]
            let nightPart = NSMutableAttributedString(string: "Night", attributes: attributesNight)
            
            let attributesWing: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.blue,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.black
            ]
            let wingPart = NSMutableAttributedString(string: "wing", attributes: attributesWing)
            
            nightPart.append(wingPart)
            return nightPart
            
        case "Poison Ivy":
            let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.green]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Riddler":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.purple,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.green
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
            
        case "Robin":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.green
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)

        case "Penguin":
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.strokeColor: UIColor.black
            ]
            return NSMutableAttributedString(string: name, attributes: attributes)
        
        case "Two-Face":
            let color = UIColor(displayP3Red: 255/255, green: 206/255, blue: 180/255, alpha: 1)
            let attributesTwo: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.strokeWidth: -1.0,
                NSAttributedString.Key.strokeColor: UIColor.white
            ]
            let twoPart = NSMutableAttributedString(string: "Two-", attributes: attributesTwo)
            
            let attributesFace: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.purple,
                NSAttributedString.Key.strokeWidth: -1.0,
                NSAttributedString.Key.strokeColor: UIColor.white
            ]
            let facePart = NSMutableAttributedString(string: "Face", attributes: attributesFace)
            
            twoPart.append(facePart)
            return twoPart
            
        default:
            return NSMutableAttributedString(string: name, attributes: [:])
        }
    }
    
}
