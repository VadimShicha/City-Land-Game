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
    var uiOpen = false;
    
    let minCameraScale: CGFloat = 0.5; //the minimum you can zoom the camera out
    let maxCameraScale: CGFloat = 15; //the maximum you can zoom the camera out/
    
    
    var materialBrickLabel = SKLabelNode();
    var materialPlanksLabel = SKLabelNode();
    var materialDiamondLabel = SKLabelNode();
    var materialMudLabel = SKLabelNode();
    var materialClayLabel = SKLabelNode();
    var materialWoodLabel = SKLabelNode();
    var materialFrozenWoodLabel = SKLabelNode();
    
    var materialBrickNode = SKSpriteNode();
    var materialPlanksNode = SKSpriteNode();
    var materialDiamondNode = SKSpriteNode();
    var materialMudNode = SKSpriteNode();
    var materialClayNode = SKSpriteNode();
    var materialWoodNode = SKSpriteNode();
    var materialFrozenWoodNode = SKSpriteNode();
    
    var attackMenuUI: AttackMenuUI!;
    var currentAttackSelected = LandTileData();
    
    var shopButtonNode = SKSpriteNode();
    var shopMenuUI: ShopMenuUI!;
    
    var settingsButtonNode = SKSpriteNode();
    var settingsMenuUI: SettingsMenuUI!;
    
    //creates the material label nodes
    func setupMaterialLabels() {
        let materialNodeSize: CGFloat = 40;
        let rawMaterialNodeSize: CGFloat = 25;
        let rawMaterialBaseY = materialNodeSize * 3;
        let rawMaterialFontSize: CGFloat = 18;
        
        materialBrickNode = SKSpriteNode(imageNamed: "Materials/Brick");
        materialBrickNode.size = CGSize(width: materialNodeSize, height: materialNodeSize);
        materialBrickNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialBrickNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialBrickNode.frame.height / 2)
        );
        materialBrickNode.zPosition = 100;
        self.camera?.addChild(materialBrickNode);
        
        materialPlanksNode = SKSpriteNode(imageNamed: "Materials/Planks");
        materialPlanksNode.size = CGSize(width: materialNodeSize, height: materialNodeSize);
        materialPlanksNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialPlanksNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialPlanksNode.frame.height / 2) - (materialNodeSize - 5)
        );
        materialPlanksNode.zPosition = 100;
        self.camera?.addChild(materialPlanksNode);

        materialDiamondNode = SKSpriteNode(imageNamed: "Materials/Diamond");
        materialDiamondNode.size = CGSize(width: materialNodeSize, height: materialNodeSize);
        materialDiamondNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialDiamondNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialDiamondNode.frame.height / 2) - ((materialNodeSize * 2) - 10)
        );
        materialDiamondNode.zPosition = 100;
        self.camera?.addChild(materialDiamondNode);
        
        
        
        materialBrickLabel.text = "1 000 000";
        materialBrickLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + materialNodeSize + 5,
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
            x: GameTools.leftCenterWidth + materialNodeSize + 5,
            y: GameTools.topCenterHeight - materialPlanksLabel.frame.height - (materialNodeSize - 5)
        );
        materialPlanksLabel.zPosition = 100;
        materialPlanksLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialPlanksLabel.fontName = "ChalkboardSE-Bold";
        materialPlanksLabel.fontSize = 22;
        materialPlanksLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialPlanksLabel);
        
        materialDiamondLabel.text = "10";
        materialDiamondLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + materialNodeSize + 5,
            y: GameTools.topCenterHeight - materialDiamondLabel.frame.height - ((materialNodeSize * 2) - 10)
        );
        materialDiamondLabel.zPosition = 100;
        materialDiamondLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialDiamondLabel.fontName = "ChalkboardSE-Bold";
        materialDiamondLabel.fontSize = 22;
        materialDiamondLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialDiamondLabel);
        
        
        
        materialMudNode = SKSpriteNode(imageNamed: "Materials/Mud");
        materialMudNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialMudNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialMudNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialMudNode.frame.height / 2) - rawMaterialBaseY
        );
        materialMudNode.zPosition = 100;
        self.camera?.addChild(materialMudNode);
        
        materialClayNode = SKSpriteNode(imageNamed: "Materials/Clay");
        materialClayNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialClayNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialClayNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialClayNode.frame.height / 2) - rawMaterialBaseY - rawMaterialNodeSize
        );
        materialClayNode.zPosition = 100;
        self.camera?.addChild(materialClayNode);
        
        materialWoodNode = SKSpriteNode(imageNamed: "Materials/Wood");
        materialWoodNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialWoodNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialWoodNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialWoodNode.frame.height / 2) - rawMaterialBaseY - (rawMaterialNodeSize * 2)
        );
        materialWoodNode.zPosition = 100;
        self.camera?.addChild(materialWoodNode);
        
        materialFrozenWoodNode = SKSpriteNode(imageNamed: "Materials/FrozenWood");
        materialFrozenWoodNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialFrozenWoodNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialFrozenWoodNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialFrozenWoodNode.frame.height / 2) - rawMaterialBaseY - (rawMaterialNodeSize * 3)
        );
        materialFrozenWoodNode.zPosition = 100;
        self.camera?.addChild(materialFrozenWoodNode);
        
        
        
        materialMudLabel.text = "10";
        materialMudLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 25 + 5,
            y: GameTools.topCenterHeight - materialMudLabel.frame.height - (rawMaterialBaseY - 8)
        );
        materialMudLabel.zPosition = 100;
        materialMudLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialMudLabel.fontName = "ChalkboardSE-Bold";
        materialMudLabel.fontSize = rawMaterialFontSize;
        materialMudLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialMudLabel);
        
        materialClayLabel.text = "10";
        materialClayLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 25 + 5,
            y: GameTools.topCenterHeight - materialClayLabel.frame.height - (rawMaterialBaseY - 8) - rawMaterialNodeSize
        );
        materialClayLabel.zPosition = 100;
        materialClayLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialClayLabel.fontName = "ChalkboardSE-Bold";
        materialClayLabel.fontSize = rawMaterialFontSize;
        materialClayLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialClayLabel);
        
        materialWoodLabel.text = "10";
        materialWoodLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 25 + 5,
            y: GameTools.topCenterHeight - materialWoodLabel.frame.height - (rawMaterialBaseY - 8) - (rawMaterialNodeSize * 2)
        );
        materialWoodLabel.zPosition = 100;
        materialWoodLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialWoodLabel.fontName = "ChalkboardSE-Bold";
        materialWoodLabel.fontSize = rawMaterialFontSize;
        materialWoodLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialWoodLabel);
        
        materialFrozenWoodLabel.text = "10";
        materialFrozenWoodLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 25 + 5,
            y: GameTools.topCenterHeight - materialFrozenWoodLabel.frame.height - (rawMaterialBaseY - 8) - (rawMaterialNodeSize * 3)
        );
        materialFrozenWoodLabel.zPosition = 100;
        materialFrozenWoodLabel.fontColor = #colorLiteral(red: 0.2027758712, green: 0.2182098267, blue: 0.2414048185, alpha: 1);
        materialFrozenWoodLabel.fontName = "ChalkboardSE-Bold";
        materialFrozenWoodLabel.fontSize = rawMaterialFontSize;
        materialFrozenWoodLabel.horizontalAlignmentMode = .left;
        self.camera?.addChild(materialFrozenWoodLabel);
        
        updateMaterialLabels();
    }
    
    //updates the material labels to show the amount you have
    func updateMaterialLabels() {
        materialBrickLabel.text = Tools.createDigitSeparatedString(GameTools.brickAmount, seperator: " ");
        materialPlanksLabel.text = Tools.createDigitSeparatedString(GameTools.planksAmount, seperator: " ");
        materialDiamondLabel.text = Tools.createDigitSeparatedString(GameTools.diamondAmount, seperator: " ");
        
        materialMudLabel.text = Tools.createDigitSeparatedString(GameTools.mudAmount, seperator: " ");
        materialClayLabel.text = Tools.createDigitSeparatedString(GameTools.clayAmount, seperator: " ");
        materialWoodLabel.text = Tools.createDigitSeparatedString(GameTools.woodAmount, seperator: " ");
        materialFrozenWoodLabel.text = Tools.createDigitSeparatedString(GameTools.frozenWoodAmount, seperator: " ");
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
        
        //all the swipe directions to listen for
        //let swipeDirections: [UISwipeGestureRecognizer.Direction] = [.left, .right, .up, .down];
        
        //loop through each direction and setup a separate gesture for each one
//        for direction in swipeDirections {
//            let swipeGesture = UISwipeGestureRecognizer();
//            swipeGesture.direction = direction;
//            swipeGesture.numberOfTouchesRequired = 1;
//            swipeGesture.addTarget(self, action: #selector(swipeGestureAction(_:)));
//            view.addGestureRecognizer(swipeGesture);
//        }
        
        setupMaterialLabels();
        
        attackMenuUI = AttackMenuUI(self);
        attackMenuUI.setupMenu();
        shopMenuUI = ShopMenuUI(self);
        shopMenuUI.setupMenu();
        settingsMenuUI = SettingsMenuUI(self);
        settingsMenuUI.setupMenu();

        
        shopButtonNode = SKSpriteNode(imageNamed: "Buttons/ShopButton");
        let shopButtonNodePositionX = GameTools.rightCenterWidth - (self.size.width / 16) - 3;
        let shopButtonNodePositionY = GameTools.bottomCenterHeight + (self.size.width / 16) + 3;
        shopButtonNode.position = CGPoint(x: shopButtonNodePositionX, y: shopButtonNodePositionY);
        shopButtonNode.size = CGSize(width: self.size.width / 8, height: self.size.width / 8);
        shopButtonNode.zPosition = 90;
        self.camera?.addChild(shopButtonNode);
        
        settingsButtonNode = SKSpriteNode(imageNamed: "Buttons/SettingsButton");
        let settingsButtonNodePositionX = GameTools.rightCenterWidth - (self.size.width / 32) - 1;
        let settingsButtonNodePositionY = GameTools.topCenterHeight - (self.size.width / 32) - 1;
        settingsButtonNode.position = CGPoint(x: settingsButtonNodePositionX, y: settingsButtonNodePositionY);
        settingsButtonNode.size = CGSize(width: self.size.width / 16, height: self.size.width / 16);
        settingsButtonNode.zPosition = 90;
        self.camera?.addChild(settingsButtonNode);
    }
    
//    @objc func swipeGestureAction(_ sender: UISwipeGestureRecognizer) {
//        if(uiOpen) {
//            if(sender.direction == .up || sender.direction == .down) {
//                let swipeLocation = sender.location(in: sender.view);
//                let swipeViewLocation = self.convertPoint(fromView: swipeLocation);
//                let swipedNodes = self.atPoint(swipeViewLocation);
//                
//                if(swipedNodes.contains(shopBackgroundNode)) {
//                    print("SWIPED!");
//                }
//            }
//        }
//    }
    
    var lastCameraScale: CGFloat = 0; //the camera scale when the pinch gesture began
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if(!uiOpen) {
            if(sender.state == .began) {
                lastCameraScale = cameraNode.xScale;
            }
            
            let cameraScale = Tools.clamp(value: lastCameraScale / sender.scale, min: minCameraScale, max: maxCameraScale);
            cameraNode.setScale(cameraScale);
        }
    }
    
    var touchBeganPosition: CGPoint = CGPoint.zero; //the last touch position
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!uiOpen) {
            touchBeganPosition = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let totalTouchCount = event?.allTouches?.count ?? 0;
        
        if(!uiOpen) {
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
        
        if(touches.count == 1) {
            let touchLocation = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            let touchingNodes = self.nodes(at: touchLocation); //array of all the nodes that have been touched
            
            //attack menu
            if(touchingNodes.contains(attackMenuUI.buttonLabel)) {
                GameTools.currentBattleLandType = currentAttackSelected.landType;
                GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: currentAttackSelected.battleGeneratorData);
                
                Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                return;
            }
            if(touchingNodes.contains(attackMenuUI.closeLabelBackground)) {
                attackMenuUI.hideMenu();
                uiOpen = false;
                
                //remove the temp clouds
                GameTools.borderNodesParent.removeAllChildren();
                let borderNodes = LandGenerator.generateCapturedBorders();
                
                for k in 0..<borderNodes.count {
                    GameTools.borderNodesParent.addChild(borderNodes[k]);
                }
            }
            //shop menu
            if(touchingNodes.contains(shopButtonNode)) {
                if(!uiOpen) {
                    shopMenuUI.showMenu();
                    uiOpen = true;
                }
            }
            if(touchingNodes.contains(shopMenuUI.closeLabelBackground)) {
                shopMenuUI.hideMenu();
                uiOpen = false;
            }
            //settings menu
            if(touchingNodes.contains(settingsButtonNode)) {
                settingsMenuUI.showMenu();
                uiOpen = true;
            }
            if(touchingNodes.contains(settingsMenuUI.closeLabelBackground)) {
                settingsMenuUI.hideMenu();
                uiOpen = false;
            }
            if(touchingNodes.contains(settingsMenuUI.saveDataButtonNode)) {
                settingsMenuUI.saveDataButtonNode.texture = SKTexture(imageNamed: "Buttons/SavingDataButton");
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    settingsMenuUI.saveDataButtonNode.texture = SKTexture(imageNamed: "Buttons/SaveDataButton");
                }
            }
        }
        
        if(!uiOpen) {
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
                            
                            GameTools.capturedLands[posX][posY].captured = true; //set the land captured so the clouds generate with the selected land

                            GameTools.borderNodesParent.removeAllChildren();
                            let borderNodes = LandGenerator.generateCapturedBorders();
                            for k in 0..<borderNodes.count {
                                GameTools.borderNodesParent.addChild(borderNodes[k]);
                            }
                            
                            GameTools.capturedLands[posX][posY].captured = false; //set the land uncaptured after generating the borders
                            
                            GameTools.currentBattleLandType = GameTools.capturedLands[posX][posY].landType;
                            GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: GameTools.capturedLands[posX][posY].battleGeneratorData);
                            GameTools.currentBattleLandPosition = GameVector2Int(x: posX, y: posY);
                            
                            currentAttackSelected = GameTools.capturedLands[posX][posY];
                            attackMenuUI.showMenu(landTileData: GameTools.capturedLands[posX][posY]);
                            uiOpen = true;
                            //Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                        }
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
