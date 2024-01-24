//
//  BattleScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/20/24.
//

import Foundation;
import SpriteKit;

//struct for holding all the data for the defenses you could use
struct DefenseData {
    var name: String = "Defense";
    var sizeTiles: Int = 3;
    var texture = SKTexture();
}

class BattleScene: SKScene {
    var cameraNode = SKCameraNode();
    
    let lightTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 15 / 255);
    let darkTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 45 / 255);
    
    var addDefenseParent = SKNode();
    var addDefenseNodes: [SKSpriteNode] = [];
    
    var placedDefenseNodes: [SKSpriteNode] = [];
    
    var showAddDefenseButton = SKSpriteNode();
    
    let availableDefenses: [DefenseData] = [
        DefenseData(name: "Catapult", sizeTiles: 4, texture: SKTexture(imageNamed: "Catapult"))
    ];
    
    var tileSize: CGFloat = 0; //size of each tile based on screen size
    
    var stonePathTiles: [SKSpriteNode] = [];
    var stonePathTilesParent = SKSpriteNode();
    
    func framesTouching(frame1: CGRect, frame2: CGRect) -> Bool {
        let xDistance = abs(frame1.midX - frame2.midX);
        let yDistance = abs(frame1.midY - frame2.midY);
        
        let framesXWidth = (frame1.width / 2) + (frame2.width / 2);
        let framesXHeight = (frame1.height / 2) + (frame2.height / 2);
        
        if(xDistance <= framesXWidth && yDistance <= framesXHeight) { return true; }
        return false;
    }
    
    override func didMove(to view: SKView) {
        tileSize = CGFloat(self.size.width / 30);
        
        let backgroundNode = SKSpriteNode(imageNamed: "GreenLandsBackground");
        backgroundNode.size = CGSize(width: 1024, height: 512);
        backgroundNode.position = CGPoint.zero;
        backgroundNode.zPosition = -10;
        self.addChild(backgroundNode);
        
        //generate the stone path where attacks come from
        for i in -15...15 {
            let stonePathTile = SKSpriteNode(imageNamed: "StonePathTile");
            stonePathTile.size = CGSize(width: 45, height: 45);
            stonePathTile.position = CGPoint(x: i * 45, y: 0);
            stonePathTiles.append(stonePathTile);
            stonePathTilesParent.addChild(stonePathTile);
        }
        self.addChild(stonePathTilesParent);
        
        var lightColorGridTile = true;
        for y in -7...7 {
            if(y == -1 || y == 0 || y == 1) { continue; }
            for x in -14...14 {
                let gridTileNode = SKSpriteNode(color: lightColorGridTile ? lightTileColor : darkTileColor, size: CGSize(width: tileSize, height: tileSize));
                gridTileNode.position = CGPoint(x: CGFloat(x) * tileSize, y: CGFloat(y) * tileSize);
                self.addChild(gridTileNode);
                lightColorGridTile = !lightColorGridTile;
            }
        }
        
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

        for i in 0..<availableDefenses.count {
            let defenseNode = SKSpriteNode(texture: availableDefenses[i].texture)
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
    
    var movableDefenseNode = SKSpriteNode();
    var moveableDefenseNodeExists = false; //is there a defense that is currently movable
    
    var movableDefenseData = DefenseData(); //data of the currently movable defense
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            for i in 0..<addDefenseNodes.count {
                if(self.nodes(at: location).contains(addDefenseNodes[i])) {
                    movableDefenseData = availableDefenses[i];
                    movableDefenseNode = addDefenseNodes[i].copy() as! SKSpriteNode;
                    let movableDefenseNodeSize = tileSize * CGFloat(availableDefenses[i].sizeTiles);
                    movableDefenseNode.size = CGSize(width: movableDefenseNodeSize, height: movableDefenseNodeSize);
                    moveableDefenseNodeExists = true;
                    self.addChild(movableDefenseNode);
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(moveableDefenseNodeExists) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            movableDefenseNode.position = location;
            
            if(self.nodes(at: location).contains(movableDefenseNode)) {
                var defenseTouchingPath = false;
                
                for i in 0..<stonePathTiles.count {
                    if(framesTouching(frame1: movableDefenseNode.frame, frame2: stonePathTiles[i].frame)) { defenseTouchingPath = true; }
                }
                
                if(defenseTouchingPath) {
                    movableDefenseNode.color = .red;
                    movableDefenseNode.colorBlendFactor = 0.75;
                }
                else {
                    movableDefenseNode.color = .clear;
                    movableDefenseNode.colorBlendFactor = 0.0;
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            if(self.nodes(at: location).contains(movableDefenseNode)) {
                var defenseTouchingPath = false;
                
                for i in 0..<stonePathTiles.count {
                    if(framesTouching(frame1: movableDefenseNode.frame, frame2: stonePathTiles[i].frame)) { defenseTouchingPath = true; }
                }
                
                if(!defenseTouchingPath) {
                    placedDefenseNodes.append(movableDefenseNode);
                    moveableDefenseNodeExists = false;
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
