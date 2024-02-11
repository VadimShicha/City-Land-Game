//
//  GameScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import SpriteKit;
import GameplayKit;

class GameScene: SKScene {
    
    var cameraNode = SKCameraNode();
    
    var lastTouch: CGPoint?; //the point of where the last touch happened. nil if there isn't any touches
    
    let minCameraScale: CGFloat = 0.5; //the minimum you can zoom the camera out
    let maxCameraScale: CGFloat = 15; //the maximum you can zoom the camera out/
    
    var attackBackgroundNode = SKShapeNode();
    var attackButtonLabel = SKLabelNode();
    var attackTitleLabel = SKLabelNode();
    
    var currentAttackSelected = LandTileData();
    
    func showStartAttackMenu(landTileData: LandTileData) {
        attackBackgroundNode.isHidden = false;
        
        attackButtonLabel.isHidden = false;
        attackTitleLabel.text = "Battle in " + landTileData.landType.rawValue;
        attackTitleLabel.isHidden = false;
        
        currentAttackSelected = landTileData;
    }
    
    override func didMove(to view: SKView) {
        let generatedLandNodes = LandGenerator.generateLandMap(); //generate the land map
        for i in 0..<generatedLandNodes.count {
            self.addChild(generatedLandNodes[i]); //add the land node to the view
        }
        
        for x in -1...1 {
            for y in -1...1 {
                GameTools.capturedLands[GameTools.mapSpawnX + x][GameTools.mapSpawnY + y].captured = true;
            }
        }
        
        
//        borderNodes = LandGenerator.generateCapturedBorders();
//        for i in 0..<borderNodes.count {
//            self.addChild(borderNodes[i]);
//        }
        
        GameTools.borderNodesParent = SKSpriteNode(color: SKColor.red, size: CGSize(width: 0, height: 0));
        let borderNodes = LandGenerator.generateCapturedBorders();
        for i in 0..<borderNodes.count {
            GameTools.borderNodesParent.addChild(borderNodes[i]);
        }
        
        self.addChild(GameTools.borderNodesParent);
        
        let cityHall = SKSpriteNode(imageNamed: "CityHall");
        cityHall.position = CGPoint(x: (GameTools.mapSpawnX * GameTools.landTileSize) + (GameTools.landTileSize / 2), y: (GameTools.mapSpawnY * GameTools.landTileSize) + (GameTools.landTileSize / 2));
        cityHall.size = CGSize(width: 512, height: 512);
        cityHall.zPosition = 1;
        self.addChild(cityHall);
        
        cameraNode.position = CGPoint(x: GameTools.mapWidth * (GameTools.landTileSize / 2), y: GameTools.mapHeight * (GameTools.landTileSize / 2));
        cameraNode.setScale(maxCameraScale / 4);
        self.camera = cameraNode;
        self.addChild(cameraNode);
        
        //setup the pinch gesture that is used for zooming
        let pinchGesture = UIPinchGestureRecognizer();
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)));
        view.addGestureRecognizer(pinchGesture);
        
        attackBackgroundNode = SKShapeNode(rect: CGRect(
            x: -self.size.width / 1.25 / 2,
            y: -self.size.height / 1.25 / 2,
            width: self.size.width / 1.25,
            height: self.size.height / 1.25
        ), cornerRadius: 14);
        attackBackgroundNode.zPosition = 90;
        attackBackgroundNode.lineWidth = 10;
        attackBackgroundNode.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
        attackBackgroundNode.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
        attackBackgroundNode.isHidden = true;
        self.camera?.addChild(attackBackgroundNode);
        
        attackButtonLabel.position = CGPoint(x: 0, y: -self.size.height / 3);
        attackButtonLabel.zPosition = 100;
        attackButtonLabel.text = "Start War";
        attackButtonLabel.fontName = "ChalkboardSE-Bold";
        attackButtonLabel.fontSize = 20;
        attackButtonLabel.isHidden = true;
        self.camera?.addChild(attackButtonLabel);
        
        let attackButtonLabelBackground = SKShapeNode(rect: CGRect(
            x: -attackButtonLabel.frame.width / 2,
            y: 0,
            width: attackButtonLabel.frame.width,
            height: attackButtonLabel.frame.height
        ), cornerRadius: 5);
        attackButtonLabelBackground.lineWidth = 10;
        attackButtonLabelBackground.fillColor = GameTools.uiColor;
        attackButtonLabelBackground.strokeColor = GameTools.uiColor;
        attackButtonLabel.addChild(attackButtonLabelBackground);
        
        attackTitleLabel.position = CGPoint(x: 0, y: self.size.height / 3);
        attackTitleLabel.zPosition = 100;
        attackTitleLabel.text = "Battle in Greenlands";
        attackTitleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        attackTitleLabel.fontName = "ChalkboardSE-Bold";
        attackTitleLabel.fontSize = 30;
        attackTitleLabel.isHidden = true;
        self.camera?.addChild(attackTitleLabel);
    }
    
    var lastCameraScale: CGFloat = 0; //the camera scale when the pinch gesture began
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if(sender.state == .began) {
            lastCameraScale = cameraNode.xScale;
        }
        
        let cameraScale = Tools.clamp(value: lastCameraScale / sender.scale, min: minCameraScale, max: maxCameraScale);
        cameraNode.setScale(cameraScale);
    }
    
    var touchBeganPosition: CGPoint = CGPoint.zero; //the last touch position
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchBeganPosition = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let totalTouchCount = event?.allTouches?.count ?? 0;
        
        //if there is only 1 touch then move the camera
        if(totalTouchCount == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            if(lastTouch == nil) {
                lastTouch = location;
                return;
            }

            let cameraMoveAction = SKAction.move(by: CGVector(dx: -(location.x - lastTouch!.x), dy: -(location.y - lastTouch!.y)), duration: 0.1);
            cameraMoveAction.timingMode = .linear;
            cameraNode.run(cameraMoveAction);
            
            lastTouch = location;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
        
        if(touches.count == 1) {
            let touchLocation = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            if(self.nodes(at: touchLocation).contains(attackButtonLabel)) {
                print("attack");
                
                GameTools.currentBattleLandType = currentAttackSelected.landType;
                GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorType: currentAttackSelected.battleGeneratorType);
                
                Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                return;
            }
        }
        
        for i in 0..<touches.count {
            let touchingNodes = self.nodes(at: touches[touches.index(touches.startIndex, offsetBy: i)].location(in: self));
            
            for j in 0..<touchingNodes.count {
                if(touchingNodes[j].name != nil && touchingNodes[j].name!.hasPrefix("LandNode:")) {
                    let newTouchBeganPosition = touches[touches.index(touches.startIndex, offsetBy: i)].location(in: self);
                    if(abs(touchBeganPosition.x - newTouchBeganPosition.x) <= 10 && abs(touchBeganPosition.y - newTouchBeganPosition.y) <= 10) {
                        
                        let positionsArray = touchingNodes[j].name!.dropFirst(9).components(separatedBy: ",");
                        if(positionsArray.count != 2) {
                            print("LandNode name doesn't contain position");
                            return;
                        }
                        let posX = Int(positionsArray[0])!;
                        let posY = Int(positionsArray[1])!;
                        
                        //if the land tapped is already captured, break out
                        if(GameTools.capturedLands[posX][posY].captured) { break; }
                        
                        GameTools.capturedLands[posX][posY].captured = true;

                        GameTools.borderNodesParent.removeAllChildren();
                        let borderNodes = LandGenerator.generateCapturedBorders();
                        
                        for k in 0..<borderNodes.count {
                            GameTools.borderNodesParent.addChild(borderNodes[k]);
                        }
                        
                        print(GameTools.capturedLands[posX][posY].battleGeneratorType);
                        GameTools.currentBattleLandType = GameTools.capturedLands[posX][posY].landType;
                        GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorType: GameTools.capturedLands[posX][posY].battleGeneratorType);
                        
                        showStartAttackMenu(landTileData: GameTools.capturedLands[posX][posY]);
                        //Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                    }
                }
            }
        }
        touchBeganPosition = CGPoint.zero;
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
        touchBeganPosition = CGPoint.zero;
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
