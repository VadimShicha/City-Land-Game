//
//  LandGenerator.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/19/24.
//

import Foundation;
import SpriteKit;
import GameplayKit;

//class used to generate land maps
class LandGenerator {
    
    //creates a noise map with the width, height and persistency
    static func createNoiseMap(width: CGFloat, height: CGFloat, persistance: CGFloat = 0.9) -> GKNoiseMap {
        let source = GKPerlinNoiseSource();
        source.persistence = persistance; //how likely the noise values are to change. The higher the more often
        
        let noise = GKNoise(source);
        let size = vector2(1.0, 1.0);
        let origin = vector2(0.0, 0.0);
        let sampleCount = vector2(Int32(width), Int32(height))
        
        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true);
    }
    
    //generates the whole land map
    static func generateLandMap() -> [SKSpriteNode] {
        let noiseMap = createNoiseMap(width: CGFloat(GameTools.mapWidth), height: CGFloat(GameTools.mapHeight), persistance: 0.9);
        var landNodes: [SKSpriteNode] = [];
        
        for x in 0..<GameTools.mapWidth {
            for y in 0..<GameTools.mapHeight {
                let noisePosition = vector2(Int32(x), Int32(y));
                let noiseValue = noiseMap.value(at: noisePosition);
                
                var landType = BattleLandType.GrassLands;
                
                var tileTexture = SKTexture();
                tileTexture = SKTexture(imageNamed: "Land/GrassLand");
                
                var materialMultiplier: CGFloat = 1; //the multiplier of each material (based on difficulty)
                
                let tileDistanceXFromSpawn = abs(x - GameTools.mapSpawnX); //tile distance of the current tile from the spawn x tile
                let tileDistanceYFromSpawn = abs(y - GameTools.mapSpawnY); //tile distance of the current tile from the spawn y tile
                var biggerTileDistanceFromSpawn = tileDistanceXFromSpawn; //biggest distance of the x and y from the spawn tile
                
                if(tileDistanceYFromSpawn > tileDistanceYFromSpawn) { biggerTileDistanceFromSpawn = tileDistanceYFromSpawn; }
                
                var battleGeneratorData = BattleGeneratorData(difficulty: BattleDifficulty.Easy, forcesType: TankDataEnum.GreenTank, id: 1);
                
                if(biggerTileDistanceFromSpawn <= 3) {
                    battleGeneratorData = BattleGeneratorData(difficulty: BattleDifficulty.Easy, forcesType: TankDataEnum.GreenTank, id: 1);
                }
                else if(biggerTileDistanceFromSpawn <= 4) {
                    battleGeneratorData = BattleGeneratorData(difficulty: BattleDifficulty.Medium, forcesType: TankDataEnum.GreenTank, id: 1);
                    materialMultiplier = 1.5;
                }
                else if(biggerTileDistanceFromSpawn <= 5) {
                    battleGeneratorData = BattleGeneratorData(difficulty: BattleDifficulty.Easy, forcesType: TankDataEnum.TanTank, id: 1);
                    materialMultiplier = 2.5;
                }
                else {
                    battleGeneratorData = BattleGeneratorData(difficulty: BattleDifficulty.Medium, forcesType: TankDataEnum.TanTank, id: 1);
                    materialMultiplier = 4;
                }
                
                GameTools.capturedLands[x][y].battleGeneratorData = battleGeneratorData;
                
                var materials: [MaterialData] = [];
                
                if(noiseValue > 0.925) { //0.85
                    tileTexture = SKTexture(imageNamed: "Land/WaterLand");
                    landType = BattleLandType.Ocean;
                    materials = [
                        MaterialData(type: MaterialType.Mud, amount: Int(50 * materialMultiplier)),
                        MaterialData(type: MaterialType.Clay, amount: Int(50 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 1)
                    ];
                }
                else if(noiseValue > 0.75) {
                    tileTexture = SKTexture(imageNamed: "Land/SandLand");
                    landType = BattleLandType.Sand;
                    materials = [
                        MaterialData(type: MaterialType.Mud, amount: Int(10 * materialMultiplier)),
                        MaterialData(type: MaterialType.Wood, amount: Int(30 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 1)
                    ];
                }
                else if(noiseValue > 0.07) {
                    tileTexture = SKTexture(imageNamed: "Land/GrassLand"); //other option: "Land/GrassLandWithBorder"
                    landType = BattleLandType.GrassLands;
                    materials = [
                        MaterialData(type: MaterialType.Mud, amount: Int(50 * materialMultiplier)),
                        MaterialData(type: MaterialType.Wood, amount: Int(20 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 1)
                    ];
                }
                else if(noiseValue > 0.01) {
                    tileTexture = SKTexture(imageNamed: "Land/ForestLand");
                    landType = BattleLandType.Forest;
                    materials = [
                        MaterialData(type: MaterialType.Mud, amount: Int(5 * materialMultiplier)),
                        MaterialData(type: MaterialType.Wood, amount: Int(65 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 1)
                    ];
                }
                else if(noiseValue > -0.3) {
                    tileTexture = SKTexture(imageNamed: "Land/MountainLand");
                    landType = BattleLandType.StoneyMountains;
                    materials = [
                        MaterialData(type: MaterialType.Clay, amount: Int(55 * materialMultiplier)),
                        MaterialData(type: MaterialType.Wood, amount: Int(15 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 1)
                    ];
                }
                else if(noiseValue > -0.7) {
                    tileTexture = SKTexture(imageNamed: "Land/SnowLand");
                    landType = BattleLandType.SnowyFields;
                    materials = [
                        MaterialData(type: MaterialType.Mud, amount: Int(20 * materialMultiplier)),
                        MaterialData(type: MaterialType.FrozenWood, amount: Int(50 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 1)
                    ];
                }
                else {
                    tileTexture = SKTexture(imageNamed: "Land/IceLand");
                    landType = BattleLandType.IcePeak;
                    materials = [
                        MaterialData(type: MaterialType.Clay, amount: Int(30 * materialMultiplier)),
                        MaterialData(type: MaterialType.FrozenWood, amount: Int(40 * materialMultiplier)),
                        MaterialData(type: MaterialType.Diamond, amount: 2)
                    ];
                }
                
                if(x == 0 || x == GameTools.mapWidth - 1 || y == 0 || y == GameTools.mapHeight - 1) {
                    tileTexture = SKTexture(imageNamed: "Land/BorderLand");
                }
                
                if((x == GameTools.mapSpawnX || x == GameTools.mapSpawnX + 1) && (y == GameTools.mapSpawnY || y == GameTools.mapSpawnY + 1)) {
                    //tileTexture = SKTexture(imageNamed: "IceLand");
                }
                
                for i in 0..<GameTools.mapSpecialLands.count {
                    if(x == GameTools.mapSpecialLands[i].x && y == GameTools.mapSpecialLands[i].y) {
                        tileTexture = GameTools.mapSpecialLands[i].landData.texture;
                        landType = GameTools.mapSpecialLands[i].landData.landType;
                    }
                }
                
                GameTools.capturedLands[x][y].texture = tileTexture;
                GameTools.capturedLands[x][y].landType = landType;
                GameTools.capturedLands[x][y].materials = materials;
                
                let landNode = SKSpriteNode(texture: tileTexture, size: CGSize(width: GameTools.landTileSize, height: GameTools.landTileSize));
                landNode.position = CGPoint(x: x * GameTools.landTileSize, y: y * GameTools.landTileSize);
                landNode.zPosition = -1;
                landNode.name = "LandNode:" + String(x) + "," + String(y);
                landNodes.append(landNode);
            }
        }
        
        return landNodes;
    }
    
    //generates an array of border nodes for the captured lands
    static func generateCapturedBorders() -> [SKSpriteNode] {
        var borderNodes: [SKSpriteNode] = [];
        
        for x in 0..<GameTools.capturedLands.count {
            for y in 0..<GameTools.capturedLands[x].count {
                if(GameTools.capturedLands[x][y].captured) {
                    //top wall
                    if(!GameTools.capturedLands[x][y + 1].captured) {
                        let borderNode = SKSpriteNode(imageNamed: "CloudWallSide");
                        borderNode.zRotation = Tools.degToRad(90);
                        borderNode.size = CGSize(width: GameTools.landTileSize / 2, height: GameTools.landTileSize);
                        borderNode.position = CGPoint(x: x * GameTools.landTileSize, y: y * GameTools.landTileSize + (GameTools.landTileSize / 2));
                        borderNode.zPosition = 0;
                        borderNodes.append(borderNode);
                    }
                    //bottom wall
                    if(!GameTools.capturedLands[x][y - 1].captured) {
                        let borderNode = SKSpriteNode(imageNamed: "CloudWallSide");
                        borderNode.zRotation = Tools.degToRad(90);
                        borderNode.size = CGSize(width: GameTools.landTileSize / 2, height: GameTools.landTileSize);
                        borderNode.position = CGPoint(x: x * GameTools.landTileSize, y: y * GameTools.landTileSize - (GameTools.landTileSize / 2));
                        borderNode.zPosition = 5;
                        borderNodes.append(borderNode);
                    }
                    //right wall
                    if(!GameTools.capturedLands[x + 1][y].captured) {
                        let borderNode = SKSpriteNode(imageNamed: "CloudWallSide");
                        borderNode.size = CGSize(width: GameTools.landTileSize / 2, height: GameTools.landTileSize);
                        borderNode.position = CGPoint(x: x * GameTools.landTileSize + (GameTools.landTileSize / 2), y: y * GameTools.landTileSize);
                        borderNode.zPosition = 3;
                        borderNodes.append(borderNode);
                    }
                    //left wall
                    if(!GameTools.capturedLands[x - 1][y].captured) {
                        let borderNode = SKSpriteNode(imageNamed: "CloudWallSide");
                        borderNode.size = CGSize(width: GameTools.landTileSize / 2, height: GameTools.landTileSize);
                        borderNode.position = CGPoint(x: x * GameTools.landTileSize - (GameTools.landTileSize / 2), y: y * GameTools.landTileSize);
                        borderNode.zPosition = 3;
                        borderNodes.append(borderNode);
                    }
                }
                
            }
        }
        return borderNodes;
    }
}
