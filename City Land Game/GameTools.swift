//
//  GameTools.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/19/24.
//

import Foundation;
import SpriteKit;

enum MaterialType {
    case Mud
    case Clay
    case Brick
    case Wood
    case FrozenWood
    case Planks
    case Diamond
}

struct MaterialData {
    var type: MaterialType = MaterialType.Brick;
    var amount: Int = 0;
}

struct LandTileData {
    var texture: SKTexture = SKTexture(imageNamed: "NoLandData");
    var landType: BattleLandType = BattleLandType.GrassLands;
    var battleGeneratorData: BattleGeneratorData = BattleGeneratorData(difficulty: BattleDifficulty.Easy, forcesType: TankDataEnum.GreenTank, id: 1);
    var captured: Bool = false;
    var materials: [MaterialData] = [
        MaterialData(type: MaterialType.Clay, amount: 10000),
        MaterialData(type: MaterialType.Wood, amount: 10000000),
        MaterialData(type: MaterialType.Diamond, amount: 10)
    ];
}

enum BattleLandType: String {
    case GrassLands = "Grasslands"
    case Forest = "Forest"
    case Ocean = "Water Lands"
    case Sand = "Sandy Lands"
    case StoneyMountains = "Stoney Mountains"
    case SnowyFields = "Snowy Fields"
    case IcePeak = "Ice Peak"
    case CannonValley = "Cannon Valley"
}

struct BattleRoundTank {
    var tank: TankDataEnum = TankDataEnum.GreenTank;
    var node = SKSpriteNode();
    var time: CGFloat = 1; //at what time of the round does this tank spawn
    var spawned = false;
    var health: Int = 100;
}

struct BattleRoundData {
    
    var roundLength: Int = 5; //seconds
    var tanks: [BattleRoundTank] = [];
}

struct BattleData {
    var rounds = [BattleRoundData](repeating: BattleRoundData(), count: 3);
    var roundAmount: Int = 3;
}

//struct for holding data for a special land that will be the same for each map
struct SpecialLandData {
    var landData: LandTileData;
    var x: Int = 0;
    var y: Int = 0;
}

//class for managing all the game variables and functions
class GameTools {
    
    static let uiColor = #colorLiteral(red: 0.5717771864, green: 0.393343057, blue: 0.1795284801, alpha: 1);
    static let mapWidth: Int = 30; //the width of the map
    static let mapHeight: Int = 30; //the height of the map/
    
    static let mapSpawnX: Int = 15; //x-position of spawn tile
    static let mapSpawnY: Int = 15; //y-position of spawn tile/
    
    //list of all the special levels on the map (they will spawn no matter what happens with generation)
    static let mapSpecialLands: [SpecialLandData] = [
        SpecialLandData(
            landData: LandTileData(texture: SKTexture(imageNamed: "Land/CannonValleyLand"), landType: BattleLandType.CannonValley, captured: false),
            x: mapSpawnX + 3,
            y: mapSpawnY + 2
        )
    ];
    
    static let landTileSize: Int = 256; //size of the land tile texture
    
    static var capturedLands = [[LandTileData]](repeating: [LandTileData](repeating: LandTileData(), count: 100), count: 100);
    
    static var borderNodesParent: SKSpriteNode = SKSpriteNode();
    
    static var currentBattleLandType: BattleLandType = BattleLandType.GrassLands;
    
    static var currentBattleRound: Int = -1; //-1 if not in battle
    static var currentBattleLives: Int = 3;
    
    static var brickAmount: Int = 10000;
    static var planksAmount: Int = 100;
    static var diamondAmount: Int = 10;
    
    static var currentBattleData: BattleData = BattleData(
        rounds: [
            BattleRoundData(roundLength: 3, tanks: [
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3)
            ]),
            BattleRoundData(roundLength: 7, tanks: [
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 5.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 6),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 6.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 7)
            ]),
            BattleRoundData(roundLength: 7, tanks: [
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 0.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 2.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 4.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 6),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 6.5),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 7)
            ]),
            BattleRoundData(roundLength: 7, tanks: [
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 0.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 1),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 1.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 2.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 3),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 3.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 4),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 4.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 5.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 6),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 6.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 7)
            ]),
            BattleRoundData(roundLength: 3, tanks: [
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 0.5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 1.5),
                BattleRoundTank(tank: TankDataEnum.TanTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 3)
            ]),
            BattleRoundData(roundLength: 8, tanks: [
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 1),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 3),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 4),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 5),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 6),
                BattleRoundTank(tank: TankDataEnum.GreenTank, time: 7),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 8)
            ]),
            BattleRoundData(roundLength: 8, tanks: [
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 0),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 1),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 2),
                BattleRoundTank(tank: TankDataEnum.RedTank, time: 3),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 4),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 5),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 6),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 7),
                BattleRoundTank(tank: TankDataEnum.BlueTank, time: 8)
            ])
        ],
        roundAmount: 7
    );
    
    //variables for scaling nodes to fit screen size
    static let leftCenterWidth = -(UIScreen.main.bounds.size.width / 2);
    static let rightCenterWidth = UIScreen.main.bounds.size.width / 2;
    static let topCenterHeight = UIScreen.main.bounds.size.height / 2;
    static let bottomCenterHeight = -(UIScreen.main.bounds.size.height / 2);
    
    static func getMaterialAssetName(_ materialType: MaterialType) -> String {
        switch(materialType) {
            case MaterialType.Mud:
                return "Materials/Mud";
            case MaterialType.Clay:
                return "Materials/Clay";
            case MaterialType.Brick:
                return "Materials/Brick";
            case MaterialType.Wood:
                return "Materials/Wood";
            case MaterialType.FrozenWood:
                return "Materials/FrozenWood";
            case MaterialType.Planks:
                return "Materials/Planks";
            case MaterialType.Diamond:
                return "Materials/Diamond";
        }
    }
    
    static func getDifficultyIndex(_ battleDifficulty: BattleDifficulty) -> Int {
//        switch(battleDifficulty) {
//        case BattleDifficulty.VeryEasy:
//            return 0
//        }
        return 0;
    }
}
