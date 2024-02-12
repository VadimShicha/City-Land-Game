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
    
    var materialBrickLabel = SKLabelNode();
    var materialPlanksLabel = SKLabelNode();
    var materialDiamondLabel = SKLabelNode();
    
    var materialBrickNode = SKSpriteNode();
    var materialPlanksNode = SKSpriteNode();
    var materialDiamondNode = SKSpriteNode();
    
    var attackBackgroundNode = SKShapeNode();
    var attackButtonLabel = SKLabelNode();
    var attackTitleLabel = SKLabelNode();
    var attackUpperBodyLabel = SKLabelNode();
    var attackBodyLabel = SKLabelNode();
    
    var currentAttackSelected = LandTileData();
    
    //creates the material label nodes
    func setupMaterialLabels() {
        materialBrickNode = SKSpriteNode(imageNamed: "Materials/Brick");
        materialBrickNode.size = CGSize(width: 40, height: 40);
        materialBrickNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialBrickNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialBrickNode.frame.height / 2)
        );
        self.camera?.addChild(materialBrickNode);
        
        materialPlanksNode = SKSpriteNode(imageNamed: "Materials/Planks");
        materialPlanksNode.size = CGSize(width: 40, height: 40);
        materialPlanksNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialPlanksNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialPlanksNode.frame.height / 2) - 35
        );
        self.camera?.addChild(materialPlanksNode);

        materialDiamondNode = SKSpriteNode(imageNamed: "Materials/Diamond");
        materialDiamondNode.size = CGSize(width: 40, height: 40);
        materialDiamondNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialDiamondNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialDiamondNode.frame.height / 2) - 70
        );
        self.camera?.addChild(materialDiamondNode);
        
        materialBrickLabel.text = "1 000 000";
        materialBrickLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 40 + 5,
            y: GameTools.topCenterHeight - materialBrickLabel.frame.height
        );
        materialBrickLabel.zPosition = 100;
        materialBrickLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialBrickLabel.fontName = "ChalkboardSE-Bold";
        materialBrickLabel.fontSize = 22;
        materialBrickLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialBrickLabel);
        
        materialPlanksLabel.text = "1 000";
        materialPlanksLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 40 + 5,
            y: GameTools.topCenterHeight - materialPlanksLabel.frame.height - 35
        );
        materialPlanksLabel.zPosition = 100;
        materialPlanksLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialPlanksLabel.fontName = "ChalkboardSE-Bold";
        materialPlanksLabel.fontSize = 22;
        materialPlanksLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialPlanksLabel);
        
        materialDiamondLabel.text = "10";
        materialDiamondLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 40 + 5,
            y: GameTools.topCenterHeight - materialDiamondLabel.frame.height - 70
        );
        materialDiamondLabel.zPosition = 100;
        materialDiamondLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialDiamondLabel.fontName = "ChalkboardSE-Bold";
        materialDiamondLabel.fontSize = 22;
        materialDiamondLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialDiamondLabel);
        
        updateMaterialLabels();
    }
    
    //updates the material labels to show the amount you have
    func updateMaterialLabels() {
        materialBrickLabel.text = Tools.createDigitSeparatedString(GameTools.brickAmount, seperator: " ");
        materialPlanksLabel.text = Tools.createDigitSeparatedString(GameTools.planksAmount, seperator: " ");
        materialDiamondLabel.text = Tools.createDigitSeparatedString(GameTools.diamondAmount, seperator: " ");
    }
    
    func showStartAttackMenu(landTileData: LandTileData) {
        attackBackgroundNode.isHidden = false;
        
        attackButtonLabel.isHidden = false;
        attackTitleLabel.text = "Battle in " + landTileData.landType.rawValue;
        attackTitleLabel.isHidden = false;
        
        attackUpperBodyLabel.isHidden = false;
        attackUpperBodyLabel.text = """
            Coins: 1,000   XP: 10
        """;
        
        let forcesType = TankData.getTank(landTileData.battleGeneratorData.forcesType);
        
        let attackBodyLabelText = NSMutableAttributedString(string: """
            Difficulty: \(landTileData.battleGeneratorData.difficulty)
            Type of Forces: \(forcesType.name)
        """);
        let attackBodyLabelColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
        let attackBodyValueColor = #colorLiteral(red: 0.9739930458, green: 0.7904064641, blue: 0.115796683, alpha: 1);
        attackBodyLabelText.addAttribute(.font, value: UIFont(name: "ChalkboardSE-Bold", size: 25) as Any, range: NSRange(location: 0, length: attackBodyLabelText.string.count));
        attackBodyLabelText.addAttribute(.foregroundColor, value: attackBodyLabelColor, range: NSRange(location: 0, length: attackBodyLabelText.string.count));
        let splitAttackBodyText = attackBodyLabelText.string.split(separator: "\n");
        if(splitAttackBodyText.count == 2) {
            attackBodyLabelText.addAttribute(
                .foregroundColor,
                value: attackBodyValueColor,
                range: NSString(string: attackBodyLabelText.string).range(of: landTileData.battleGeneratorData.difficulty.rawValue)
            );
            attackBodyLabelText.addAttribute(
                .foregroundColor,
                value: attackBodyValueColor,
                range: NSString(string: attackBodyLabelText.string).range(of: forcesType.name)
            );
        }
        attackBodyLabel.attributedText = attackBodyLabelText;
        attackBodyLabel.isHidden = false;
        
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
        
        setupMaterialLabels();
        
        attackBackgroundNode = SKShapeNode(rect: CGRect(
            x: -self.size.width / 1.25 / 2,
            y: -self.size.height / 1.25 / 2,
            width: self.size.width / 1.25,
            height: self.size.height / 1.25
        ), cornerRadius: 14);
        attackBackgroundNode.zPosition = 90;
        attackBackgroundNode.lineWidth = 0;
        attackBackgroundNode.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.8);
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
        
        attackUpperBodyLabel.position = CGPoint(x: 0, y: self.size.height / 6);
        attackUpperBodyLabel.zPosition = 100;
        attackUpperBodyLabel.text = "Upper Body Text";
        //attackUpperBodyLabel.numberOfLines = 3;
        attackUpperBodyLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
        attackUpperBodyLabel.fontName = "ChalkboardSE-Bold";
        attackUpperBodyLabel.fontSize = 25;
        attackUpperBodyLabel.horizontalAlignmentMode = .center;
        attackUpperBodyLabel.isHidden = true;
        self.camera?.addChild(attackUpperBodyLabel);
        
        attackBodyLabel.position = CGPoint(x: 0, y: 0);
        attackBodyLabel.zPosition = 100;
        attackBodyLabel.text = "Battle Body Text";
        attackBodyLabel.numberOfLines = 3;
        attackBodyLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
        attackBodyLabel.fontName = "ChalkboardSE-Bold";
        attackBodyLabel.fontSize = 25;
        attackBodyLabel.horizontalAlignmentMode = .center;
        attackBodyLabel.isHidden = true;
        self.camera?.addChild(attackBodyLabel);
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
            
            var newCameraPositionX = cameraNode.position.x + -(location.x - lastTouch!.x); //the x position of the camera after this touch
            var newCameraPositionY = cameraNode.position.y + -(location.y - lastTouch!.y); //the y position of the camera after this touch
            
            //make the camera positions be based on the center of the map rather than (0, 0)
            newCameraPositionX -= CGFloat((GameTools.mapWidth * GameTools.landTileSize) / 2);
            newCameraPositionY -= CGFloat((GameTools.mapHeight * GameTools.landTileSize) / 2);
            
            let mapWidth = GameTools.mapWidth * GameTools.landTileSize;
            let mapHeight = GameTools.mapHeight * GameTools.landTileSize;
            
            //prevent the camera from moving too far out
            if(newCameraPositionX > CGFloat(mapWidth) / 1.25) { return; }
            if(newCameraPositionX < -CGFloat(mapWidth) / 1.25) { return; }
            if(newCameraPositionY > CGFloat(mapHeight) / 1.25) { return; }
            if(newCameraPositionY < -CGFloat(mapHeight) / 1.25) { return; }

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
                GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: currentAttackSelected.battleGeneratorData);
                
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
                        
                        print(GameTools.capturedLands[posX][posY].battleGeneratorData);
                        GameTools.currentBattleLandType = GameTools.capturedLands[posX][posY].landType;
                        GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: GameTools.capturedLands[posX][posY].battleGeneratorData);
                        
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
