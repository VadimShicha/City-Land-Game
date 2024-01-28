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

struct BattleRoundTank {
    var tank: TankDataEnum = TankDataEnum.Tank;
    var time: CGFloat = 1; //at what time of the round does this tank spawn
    var spawned = false;
}

struct BattleRoundData {
    
    var roundLength: Int = 5; //seconds
    var tanks: [BattleRoundTank] = [];
}

struct BattleData {
    var rounds = [BattleRoundData](repeating: BattleRoundData(), count: 3);
    var roundAmount: Int = 3;
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
    
    static var currentBattleRound: Int = -1; //-1 if not in battle
    
    static var currentBattleData: BattleData = BattleData(
        rounds: [
            BattleRoundData(roundLength: 3, tanks: [
                BattleRoundTank(tank: TankDataEnum.Tank, time: 0),
                BattleRoundTank(tank: TankDataEnum.Tank, time: 0.5),
                BattleRoundTank(tank: TankDataEnum.BigTank, time: 3)
            ]),
            BattleRoundData(roundLength: 3, tanks: [
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 0.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 1),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 1.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 2.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 3)
            ]),
            BattleRoundData(roundLength: 7, tanks: [
                BattleRoundTank(tank: TankDataEnum.BigTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.BigTank, time: 3),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 4),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 4.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 5.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 6),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 6.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 7)
            ])
        ],
        roundAmount: 3
    );
    
    //variables for scaling nodes to fit screen size
    static let leftCenterWidth = -(UIScreen.main.bounds.size.width / 2);
    static let rightCenterWidth = UIScreen.main.bounds.size.width / 2;
    static let topCenterHeight = UIScreen.main.bounds.size.height / 2;
    static let bottomCenterHeight = -(UIScreen.main.bounds.size.height / 2);
}
