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
                
                var tileTexture = SKTexture();
                tileTexture = SKTexture(imageNamed: "GrassLand");
                
                if(noiseValue > 0.85) {
                    tileTexture = SKTexture(imageNamed: "WaterLand");
                }
                else if(noiseValue > 0.75) {
                    tileTexture = SKTexture(imageNamed: "SandLand");
                }
                else if(noiseValue > 0.07) {
                    tileTexture = SKTexture(imageNamed: "GrassLandWithBorder");
                }
                else if(noiseValue > 0.01) {
                    tileTexture = SKTexture(imageNamed: "ForestLand");
                }
                else if(noiseValue > -0.3) {
                    tileTexture = SKTexture(imageNamed: "MountainLand");
                }
                else if(noiseValue > -0.7) {
                    tileTexture = SKTexture(imageNamed: "SnowLand");
                }
                else {
                    tileTexture = SKTexture(imageNamed: "IceLand");
                }
                
                if(x == 0 || x == GameTools.mapWidth - 1 || y == 0 || y == GameTools.mapHeight - 1) {
                    tileTexture = SKTexture(imageNamed: "BorderLand");
                }
                
                if((x == GameTools.mapSpawnX || x == GameTools.mapSpawnX + 1) && (y == GameTools.mapSpawnY || y == GameTools.mapSpawnY + 1)) {
                    //tileTexture = SKTexture(imageNamed: "IceLand");
                }
                
                let landNode = SKSpriteNode(texture: tileTexture, size: CGSize(width: GameTools.landTileSize, height: GameTools.landTileSize));
                landNode.position = CGPoint(x: x * GameTools.landTileSize, y: y * GameTools.landTileSize);
                landNode.zPosition = -1;
                landNodes.append(landNode);
            }
        }
        
        return landNodes;
    }
    
}
