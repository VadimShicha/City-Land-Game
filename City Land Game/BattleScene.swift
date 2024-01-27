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

//struct for holding all the data for the defenses you could use
struct TankData {
    var name: String = "Tank";
    var sizeTiles: Int = 3;
    var texture = SKTexture();
}

class BattleScene: SKScene {
    var cameraNode = SKCameraNode();
    
    let lightTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 15 / 255);
    let darkTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 45 / 255);
    
    var addDefenseParent = SKSpriteNode();
    var addDefenseBackgroundNodes: [SKShapeNode] = [];
    var addDefenseNodes: [SKSpriteNode] = [];
    
    var spawnTankParent = SKSpriteNode();
    var spawnTankNodes: [SKSpriteNode] = [];
    
    var placedDefenseNodes: [SKSpriteNode] = [];
    
    var showAddDefenseButton = SKSpriteNode();
    var spawnTankButton = SKSpriteNode();
    
    let availableDefenses: [DefenseData] = [
        DefenseData(name: "Catapult", sizeTiles: 3, texture: SKTexture(imageNamed: "Catapult"))
    ];
    
    let availableTanks: [TankData] = [
        TankData(name: "Tank", sizeTiles: 3, texture: SKTexture(imageNamed: "Tank")),
        TankData(name: "BlueTank", sizeTiles: 3, texture: SKTexture(imageNamed: "BlueTank")),
        TankData(name: "RedTank", sizeTiles: 5, texture: SKTexture(imageNamed: "RedTank")),
        TankData(name: "Tank", sizeTiles: 6, texture: SKTexture(imageNamed: "Tank"))
    ];
    
    var tileSize: CGFloat = 0; //size of each tile based on screen size
    
    var stonePathTiles: [SKSpriteNode] = [];
    var stonePathTilesParent = SKSpriteNode();
    
    //checks if two frames are inside of each other (touching each other)
    func framesTouching(frame1: CGRect, frame2: CGRect) -> Bool {
        let xDistance = abs(frame1.midX - frame2.midX);
        let yDistance = abs(frame1.midY - frame2.midY);
        
        let framesXWidth = (frame1.width / 2) + (frame2.width / 2);
        let framesXHeight = (frame1.height / 2) + (frame2.height / 2);
        
        if(xDistance <= framesXWidth && yDistance <= framesXHeight) { return true; }
        return false;
    }
    
    //rounds the given number value to the nearest step amount
    //(value: 65, stepAmount: 20) -> 60
    //(value: 70, stepAmount: 20) -> 80
    //(value: 75, stepAmount: 20) -> 80
    func roundToStepAmount(value: CGFloat, stepAmount: CGFloat) -> CGFloat {
        //((69 + 10) - ((69 + 10) % 20)) / 20
        
        let newValue = value + (stepAmount / 2);
        
        return (newValue - (newValue.truncatingRemainder(dividingBy: stepAmount)));
    }
    
    //adds the metal image and metal label display to the scene
    func addMetalDisplay() {
        let negativeCenterWidth = -(self.size.width / 2);
        let centerHeight = self.size.height / 2;
        
        let metalNode = SKSpriteNode(imageNamed: "Metal");
        metalNode.size = CGSize(width: self.size.width / 15, height: self.size.width / 15);
        metalNode.position = CGPoint(
            x: negativeCenterWidth + (self.size.width / 30),
            y: centerHeight - (self.size.height / 30)
        );
        metalNode.zPosition = 100;
        self.addChild(metalNode);
        
        let metalAmountText = SKLabelNode(text: "1000");
        metalAmountText.position = CGPoint(
            x: negativeCenterWidth + (self.size.width / 15) + 5,
            y: centerHeight - metalAmountText.frame.height - 3
        );
        metalAmountText.zPosition = 100;
        metalAmountText.horizontalAlignmentMode = .left;
        metalAmountText.fontName = "ChalkboardSE-Bold";
        metalAmountText.fontSize = 20;
        self.addChild(metalAmountText);
    }
    
    func addDefenseMenu() {
        
        let negativeCenterWidth = -(self.size.width / 2);
        let negativeCenterHeight = -(self.size.height / 2);
        
        let addDefenseNodeSize = self.size.width / 16;
        showAddDefenseButton = SKSpriteNode(imageNamed: "AddButton");
        showAddDefenseButton.size = CGSize(width: addDefenseNodeSize, height: addDefenseNodeSize);
        
        let showAddDefenseButtonPositionX = negativeCenterWidth + (addDefenseNodeSize / 2);
        let showAddDefenseButtonPositionY = negativeCenterHeight + (addDefenseNodeSize / 2);
        
        showAddDefenseButton.position = CGPoint(x: showAddDefenseButtonPositionX + 5, y: showAddDefenseButtonPositionY + 5);
        showAddDefenseButton.zPosition = 100;
        self.addChild(showAddDefenseButton);

        //display all the dragable defenses
        for i in 0..<availableDefenses.count {
            
            let defenseNode = SKSpriteNode(texture: availableDefenses[i].texture)
            defenseNode.size = CGSize(width: addDefenseNodeSize, height: addDefenseNodeSize);
            defenseNode.zPosition = 95;
            let defenseNodeWidth = CGFloat(i * (Int(addDefenseNodeSize) + 5));
            
            let defenseNodePositionX = negativeCenterWidth + defenseNodeWidth + (addDefenseNodeSize * 1.5) + 5;
            let defenseNodePositionY = negativeCenterHeight + (addDefenseNodeSize / 2);
            
            defenseNode.position = CGPoint(
                x: defenseNodePositionX + 5,
                y: defenseNodePositionY + 5
            );
            
            addDefenseNodes.append(defenseNode);
            addDefenseParent.addChild(defenseNode);
            
            let defenseBackgroundNode = SKShapeNode(rect: CGRect(
                x: defenseNodePositionX + 5 - (addDefenseNodeSize / 2),
                y: defenseNodePositionY + 5 - (addDefenseNodeSize / 2),
                width: addDefenseNodeSize,
                height: addDefenseNodeSize
            ), cornerRadius: 6);
            defenseBackgroundNode.lineWidth = 0;
            defenseBackgroundNode.fillColor = .red;
            defenseBackgroundNode.zPosition = 94;
            addDefenseBackgroundNodes.append(defenseBackgroundNode);
            addDefenseParent.addChild(defenseBackgroundNode);
        }
        
        let addDefenseBackgroundNode = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: addDefenseNodeSize + 10));
        addDefenseBackgroundNode.position = CGPoint(
            x: 0,
            y: negativeCenterHeight + (addDefenseNodeSize / 2) + 5
        );
        addDefenseBackgroundNode.zPosition = 90;
        //addDefenseParent.addChild(addDefenseBackgroundNode);
        
        addDefenseParent.isHidden = true;
        self.addChild(addDefenseParent);
    }
    
    //generate the stone path where attacks come from
    func addStonePath() {
        for i in -15...15 {
            let stonePathTile = SKSpriteNode(imageNamed: "StonePathTile");
            stonePathTile.size = CGSize(width: tileSize * 2, height: tileSize * 2);
            stonePathTile.position = CGPoint(x: i * Int(tileSize) * 2, y: 0);
            stonePathTiles.append(stonePathTile);
            stonePathTilesParent.addChild(stonePathTile);
        }
        self.addChild(stonePathTilesParent);
    }
    
    //add the background node to the scene
    func addBackgroundNode() {
        let backgroundNode = SKSpriteNode(imageNamed: "GreenLandsBackground");
        backgroundNode.size = CGSize(width: 1024, height: 512);
        backgroundNode.position = CGPoint.zero;
        backgroundNode.zPosition = -10;
        self.addChild(backgroundNode);
    }
    
    //adds the background grid nodes to the scene
    func addBackgroundGrid() {
        var lightColorGridTile = true;
        
        for y in -7...7 {
            if(y == -1 || y == 0 || y == 1) { continue; }
            for x in -14...14 {
                let gridTileNode = SKSpriteNode(
                    color: lightColorGridTile ? lightTileColor : darkTileColor,
                    size: CGSize(width: tileSize, height: tileSize)
                );
                gridTileNode.position = CGPoint(
                    x: CGFloat(x) * tileSize,
                    y: CGFloat(y) * tileSize
                );
                self.addChild(gridTileNode);
                lightColorGridTile = !lightColorGridTile; //toggle the tile color bool for next cycle
            }
        }
    }
    
    func addTankSpawnMenu() {
        let negativeCenterWidth = -(self.size.width / 2);
        let negativeCenterHeight = -(self.size.height / 2);
        
        let spawnTankButtonSize = self.size.width / 16;
        spawnTankButton = SKSpriteNode(imageNamed: "TankButton");
        spawnTankButton.size = CGSize(width: spawnTankButtonSize, height: spawnTankButtonSize);
        
        let spawnTankButtonPositionX = negativeCenterWidth + (spawnTankButtonSize / 2);
        let spawnTankButtonPositionY = negativeCenterHeight + (spawnTankButtonSize / 2);
        
        spawnTankButton.position = CGPoint(x: spawnTankButtonPositionX + 5, y: spawnTankButtonPositionY + 5 + spawnTankButtonSize + 5);
        spawnTankButton.zPosition = 100;
        self.addChild(spawnTankButton);

        //display all the dragable tanks
        for i in 0..<availableTanks.count {
            let tankNode = SKSpriteNode(texture: availableTanks[i].texture)
            tankNode.size = CGSize(width: spawnTankButtonSize, height: spawnTankButtonSize);
            tankNode.zPosition = 95;
            let tankNodeWidth = CGFloat(i * (Int(spawnTankButtonSize) + 5));
            
            let tankNodePositionX = negativeCenterWidth + tankNodeWidth + (spawnTankButtonSize * 1.5);
            let tankNodePositionY = negativeCenterHeight + (spawnTankButtonSize / 2);
            
            tankNode.position = CGPoint(
                x: tankNodePositionX + 5,
                y: tankNodePositionY + 5
            );
            
            spawnTankNodes.append(tankNode);
            spawnTankParent.addChild(tankNode);
        }
        
        let spawnTankBackgroundNode = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: spawnTankButtonSize + 10));
        spawnTankBackgroundNode.position = CGPoint(
            x: 0,
            y: negativeCenterHeight + (spawnTankButtonSize / 2) + 5
        );
        spawnTankBackgroundNode.zPosition = 90;
        spawnTankParent.addChild(spawnTankBackgroundNode);
        
        spawnTankParent.isHidden = true;
        self.addChild(spawnTankParent);
    }
    
    override func didMove(to view: SKView) {
        tileSize = CGFloat(self.size.width / 30);
        
        addBackgroundNode();
        addBackgroundGrid();
        addStonePath();
        
        addMetalDisplay();
        addDefenseMenu();
        addTankSpawnMenu();
        
        cameraNode.position = CGPoint.zero;
        self.camera = cameraNode;
        self.addChild(cameraNode);
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
                    
                    setAddDefenseMenuHidden(true);
                }
            }
            
            for i in 0..<spawnTankNodes.count {
                if(self.nodes(at: location).contains(spawnTankNodes[i])) {
                    let tank = SKSpriteNode(texture: availableTanks[i].texture);
                    tank.position = CGPoint(x: -(self.size.width / 2), y: 10);
                    tank.size = CGSize(width: (Int(tileSize) * availableTanks[i].sizeTiles) + 16, height: (Int(tileSize) * availableTanks[i].sizeTiles) + 16);
                    tank.zPosition = 95;
                    self.addChild(tank);
                    
                    let tankMove = SKAction.moveBy(x: 1000, y: 0, duration: 5);
                    tank.run(tankMove);
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(moveableDefenseNodeExists) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            let movePositionX = roundToStepAmount(value: location.x, stepAmount: tileSize);
            let movePositionY = roundToStepAmount(value: location.y, stepAmount: tileSize);
            movableDefenseNode.position = CGPoint(x: movePositionX, y: movePositionY);
            
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
            
            if(moveableDefenseNodeExists) {
                if(self.nodes(at: location).contains(movableDefenseNode)) {
                    var defenseTouchingPath = false;
                    
                    for i in 0..<stonePathTiles.count {
                        if(framesTouching(frame1: movableDefenseNode.frame, frame2: stonePathTiles[i].frame)) { defenseTouchingPath = true; }
                    }
                    
                    if(!defenseTouchingPath) {
                        movableDefenseNode.zPosition = 50;
                        placedDefenseNodes.append(movableDefenseNode);
                        moveableDefenseNodeExists = false;
                        
                        movableDefenseNode.color = .green;
                        movableDefenseNode.colorBlendFactor = 0.5;
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
                            self.movableDefenseNode.color = .clear;
                            self.movableDefenseNode.colorBlendFactor = 0.0;
                        }
                    }
                }
            }
        }
        
        for touch in touches {
            if(self.nodes(at: touch.location(in: self)).contains(showAddDefenseButton)) {
                showAddDefenseMenu();
            }
            else if(self.nodes(at: touch.location(in: self)).contains(spawnTankButton)) {
                showSpawnTankMenu();
            }
        }
    }
    
    //sets hidden value for the add defense menu
    func setAddDefenseMenuHidden(_ value: Bool) {
        addDefenseParent.isHidden = value;
        showAddDefenseButton.texture = SKTexture(imageNamed: addDefenseParent.isHidden ? "AddButton" : "CloseButton");
    }
    
    //sets hidden value for the add defense menu
    func setSpawnTankMenuHidden(_ value: Bool) {
        spawnTankParent.isHidden = value;
        spawnTankButton.texture = SKTexture(imageNamed: spawnTankParent.isHidden ? "TankButton" : "CloseButton");
    }
    
    @objc func showAddDefenseMenu() {
        setAddDefenseMenuHidden(!addDefenseParent.isHidden);
    }
    
    @objc func showSpawnTankMenu() {
        setSpawnTankMenuHidden(!spawnTankParent.isHidden);
    }
}
