//
//  BattleScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/20/24.
//

import Foundation;
import SpriteKit;

class BattleScene: SKScene {
    var cameraNode = SKCameraNode();
    
    let lightTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 15 / 255);
    let darkTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 45 / 255);
    
    var addDefenseParent = SKNode();
    var addDefenseNodes: [SKSpriteNode] = [];
    
    var showAddDefenseButton = SKSpriteNode();
    
    var tileSize: CGFloat = 0;
    
    override func didMove(to view: SKView) {
        tileSize = CGFloat(self.size.width / 30);
        
        let backgroundNode = SKSpriteNode(imageNamed: "GreenLandsBackground");
        backgroundNode.size = CGSize(width: 1024, height: 512);
        backgroundNode.position = CGPoint.zero;
        backgroundNode.zPosition = -10;
        self.addChild(backgroundNode);
        
        for i in -15...15 {
            let stonePathTile = SKSpriteNode(imageNamed: "StonePathTile");
            stonePathTile.size = CGSize(width: 45, height: 45);
            stonePathTile.position = CGPoint(x: i * 45, y: 0);
            self.addChild(stonePathTile);
        }
        
        var lightColor = true;
        
        for y in -7...7 {
            if(y == -1 || y == 0 || y == 1) { continue; }
            for x in -14...14 {
                let stonePathTile = SKSpriteNode(color: lightColor ? lightTileColor : darkTileColor, size: CGSize(width: tileSize, height: tileSize));
                stonePathTile.position = CGPoint(x: CGFloat(x) * tileSize, y: CGFloat(y) * tileSize);
                self.addChild(stonePathTile);
                lightColor = !lightColor;
            }
        }
        
        let spearTower = SKSpriteNode(imageNamed: "Catapult");
        spearTower.size = CGSize(width: tileSize * 5, height: tileSize * 5);
        spearTower.position = CGPoint(x: 0, y: -5 * tileSize);
        self.addChild(spearTower);
        
        cameraNode.position = CGPoint.zero;
        self.camera = cameraNode;
        self.addChild(cameraNode);
        
        let addDefenseNodeSize = self.size.width / 16;
        
        showAddDefenseButton = SKSpriteNode(imageNamed: "AddButton");
        showAddDefenseButton.size = CGSize(width: addDefenseNodeSize, height: addDefenseNodeSize);
        let showAddDefenseButtonPositionX = -(self.size.width / 2) + (addDefenseNodeSize / 2) + 5;
        let showAddDefenseButtonPositionY = -(self.size.height / 2) + (addDefenseNodeSize / 2) + 5
        showAddDefenseButton.position = CGPoint(x: showAddDefenseButtonPositionX, y: showAddDefenseButtonPositionY);
        self.addChild(showAddDefenseButton);

        for i in 0..<10 {
            let defenseNode = SKSpriteNode(imageNamed: "Catapult");
            defenseNode.size = CGSize(width: addDefenseNodeSize, height: addDefenseNodeSize);
            defenseNode.zPosition = 5;
            let defenseNodeWidth = CGFloat(i * (Int(addDefenseNodeSize) + 5))
            defenseNode.position = CGPoint(
                x: -(self.size.width / 2) + defenseNodeWidth + (addDefenseNodeSize * 1.5) + 5,
                y: -(self.size.height / 2) + (addDefenseNodeSize / 2) + 5
            );
            
            addDefenseNodes.append(defenseNode);
            addDefenseParent.addChild(defenseNode);
        }
        addDefenseParent.isHidden = true;
        self.addChild(addDefenseParent);
    }
    
    var movableDefenseNodeIndex = -1;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            for i in 0..<addDefenseNodes.count {
                if(self.nodes(at: location).contains(addDefenseNodes[i])) {
                    movableDefenseNodeIndex = i;
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(movableDefenseNodeIndex != -1) {
            addDefenseNodes[movableDefenseNodeIndex].size = CGSize(width: tileSize * 5, height: tileSize * 5);
            addDefenseNodes[movableDefenseNodeIndex].position = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            for i in 0..<addDefenseNodes.count {
                if(self.nodes(at: location).contains(addDefenseNodes[i])) {
                    movableDefenseNodeIndex = -1;
                }
            }
        }
        
        for touch in touches {
            
            if(self.nodes(at: touch.location(in: self)).contains(showAddDefenseButton)) {
                showAddDefenseMenu();
            }
        }
    }
    
    @objc func showAddDefenseMenu() {
        addDefenseParent.isHidden = !addDefenseParent.isHidden;
    }
}
