//
//  GameTools.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/19/24.
//

import Foundation;
import SpriteKit;

struct LandTileData {
    var texture: SKTexture = SKTexture(imageNamed: "NoLandData");
    var captured: Bool = false;
}

enum BattleType {
    case GrassLands, Sand, StoneyHills
}

//class for managing all the game variables and functions
class GameTools {
    static let mapWidth: Int = 100; //the width of the map
    static let mapHeight: Int = 100; //the height of the map/
    
    static let mapSpawnX: Int = 50; //x-position of spawn tile
    static let mapSpawnY: Int = 50; //y-position of spawn tile/
    
    static let landTileSize: Int = 256; //size of the land tile texture
    
    static var capturedLands = [[LandTileData]](repeating: [LandTileData](repeating: LandTileData(), count: 100), count: 100);
    
    static var borderNodesParent: SKSpriteNode = SKSpriteNode();
    
    static var currentBattleType: BattleType = BattleType.GrassLands;
}
