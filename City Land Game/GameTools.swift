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

enum CityBuildingType: Int, CaseIterable {
    case Empty = 0
    case CityHall = 1
    case SawMill = 2
    case DiamondMine = 3
}

struct CityBuilding {
    var name: String = "City Building";
    var nodeName: String = "CityBuilding/Building";
    var buildingType = CityBuildingType.Empty;
    var sizeTiles: Int = 3;
    var texture = SKTexture();
    
    static func getCityBuilding(_ building: CityBuildingType) -> CityBuilding {
        switch(building.rawValue) {
            case 1:
            return CityBuilding(name: "City Hall", nodeName: "CityBuilding/CityHall", buildingType: CityBuildingType.CityHall, sizeTiles: 2, texture: SKTexture(imageNamed: "CityBuildings/CityHall"));
            case 2:
                return CityBuilding(name: "Saw Mill", nodeName: "CityBuilding/SawMill", buildingType: CityBuildingType.SawMill, sizeTiles: 1, texture: SKTexture(imageNamed: "CityBuildings/SawMill"));
            case 3:
                return CityBuilding(name: "Diamond Mine", nodeName: "CityBuilding/DiamondMine", buildingType: CityBuildingType.DiamondMine, sizeTiles: 1, texture: SKTexture(imageNamed: "CityBuildings/DiamondMine"));
            default:
                return CityBuilding(name: "Empty Building", nodeName: "CityBuilding/Building", buildingType: CityBuildingType.Empty, sizeTiles: 1, texture: SKTexture(imageNamed: ""));
        }
    }
}

struct PlacedCityBuilding {
    var buildingData = CityBuilding();
    var position = GameVector2Int.zero;
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
    var placedBuilding: CityBuilding = CityBuilding.getCityBuilding(CityBuildingType.Empty);
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
    static let darkUiColor = #colorLiteral(red: 0.4344117469, green: 0.297701099, blue: 0.1380777428, alpha: 1);
    static let redUiColor = #colorLiteral(red: 0.9439326605, green: 0.1655154441, blue: 0.1803022484, alpha: 1);
    
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
    static var currentBattleLandPosition: GameVector2Int = GameVector2Int.zero;
    
    static var currentBattleRound: Int = -1; //-1 if not in battle
    static var currentBattleLives: Int = 3;
    
    static var brickAmount: Int = 100;
    static var planksAmount: Int = 20;
    static var diamondAmount: Int = 10;
    
    static var mudAmount: Int = 10;
    static var clayAmount: Int = 10;
    static var woodAmount: Int = 100;
    static var frozenWoodAmount: Int = 0;
    
    static func setMaterialAmount(type: MaterialType, amount: Int) {
        switch(type) {
            case MaterialType.Brick:
                brickAmount = amount;
                break;
            case MaterialType.Planks:
                planksAmount = amount;
                break;
            case MaterialType.Diamond:
                diamondAmount = amount;
                break;
            case MaterialType.Mud:
                mudAmount = amount;
                break;
            case MaterialType.Clay:
                clayAmount = amount;
                break;
            case MaterialType.Wood:
                woodAmount = amount;
                break;
            case MaterialType.FrozenWood:
                frozenWoodAmount = amount;
                break;
        }
    }
    
    static func getMaterialAmount(type: MaterialType) -> Int {
        switch(type) {
            case MaterialType.Brick:
                return brickAmount;
            case MaterialType.Planks:
                return planksAmount;
            case MaterialType.Diamond:
                return diamondAmount;
            case MaterialType.Mud:
                return mudAmount;
            case MaterialType.Clay:
                return clayAmount;
            case MaterialType.Wood:
                return woodAmount;
            case MaterialType.FrozenWood:
                return frozenWoodAmount;
        }
    }
    
//    static var materialAmounts: [MaterialData] = [
//        MaterialData(type: MaterialType.Brick, amount: 100),
//        MaterialData(type: MaterialType.Planks, amount: 20),
//        MaterialData(type: MaterialType.Diamond, amount: 10),
//        MaterialData(type: MaterialType.Mud, amount: 10),
//        MaterialData(type: MaterialType.Clay, amount: 10),
//        MaterialData(type: MaterialType.Wood, amount: 10),
//        MaterialData(type: MaterialType.FrozenWood, amount: 0)
//    ];
    
    static var placedBuildings: [PlacedCityBuilding] = [
        PlacedCityBuilding(
            buildingData: CityBuilding.getCityBuilding(CityBuildingType.CityHall),
            position: GameVector2Int(x: GameTools.mapSpawnX, y: GameTools.mapSpawnY)
        ),
        PlacedCityBuilding(
            buildingData: CityBuilding.getCityBuilding(CityBuildingType.SawMill),
            position: GameVector2Int(x: GameTools.mapSpawnX - 1, y: GameTools.mapSpawnY)
        )
    ];
    
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
    
//    static func getCityBuildingAssetName(_ cityBuildingType: CityBuildingType) -> String {
//        switch(cityBuildingType) {
//            case CityBuildingType.CityHall:
//                return "CityBuildings/CityHall";
//            case CityBuildingType.SawMill:
//                return "CityBuildings/SawMill";
//            case CityBuildingType.DiamondMine:
//                return "CityBuildings/DiamondMine";
//            default:
//                return "";
//        }
//    }
    
    static func getDifficultyIndex(_ battleDifficulty: BattleDifficulty) -> Int {
//        switch(battleDifficulty) {
//        case BattleDifficulty.VeryEasy:
//            return 0
//        }
        return 0;
    }
}
