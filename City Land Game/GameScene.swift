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
    
    enum ZLayers: CGFloat, CaseIterable {
        case PlacedCityBuilding = 0
        case DraggedCityBuilding = 95
        case UI = 100
    }
    
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

    //var cityBuildingMenuUI: CityBuildingMenuUI!;
    var sawMillMenuUI: SawMillMenuUI!;
    
    var draggingBuildingLabel = SKLabelNode();

    
    func setUiOpen(_ value: Bool) {
        uiOpen = value;
        shopButtonNode.isHidden = value;
        settingsButtonNode.isHidden = value;
        
    }
    
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
        materialBrickNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialBrickNode);
        
        materialPlanksNode = SKSpriteNode(imageNamed: "Materials/Planks");
        materialPlanksNode.size = CGSize(width: materialNodeSize, height: materialNodeSize);
        materialPlanksNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialPlanksNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialPlanksNode.frame.height / 2) - (materialNodeSize - 5)
        );
        materialPlanksNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialPlanksNode);

        materialDiamondNode = SKSpriteNode(imageNamed: "Materials/Diamond");
        materialDiamondNode.size = CGSize(width: materialNodeSize, height: materialNodeSize);
        materialDiamondNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialDiamondNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialDiamondNode.frame.height / 2) - ((materialNodeSize * 2) - 10)
        );
        materialDiamondNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialDiamondNode);
        
        
        
        materialBrickLabel.text = "1 000 000";
        materialBrickLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + materialNodeSize + 5,
            y: GameTools.topCenterHeight - materialBrickLabel.frame.height
        );
        materialBrickLabel.zPosition = ZLayers.UI.rawValue;
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
        materialPlanksLabel.zPosition = ZLayers.UI.rawValue;
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
        materialDiamondLabel.zPosition = ZLayers.UI.rawValue;
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
        materialMudNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialMudNode);
        
        materialClayNode = SKSpriteNode(imageNamed: "Materials/Clay");
        materialClayNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialClayNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialClayNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialClayNode.frame.height / 2) - rawMaterialBaseY - rawMaterialNodeSize
        );
        materialClayNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialClayNode);
        
        materialWoodNode = SKSpriteNode(imageNamed: "Materials/Wood");
        materialWoodNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialWoodNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialWoodNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialWoodNode.frame.height / 2) - rawMaterialBaseY - (rawMaterialNodeSize * 2)
        );
        materialWoodNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialWoodNode);
        
        materialFrozenWoodNode = SKSpriteNode(imageNamed: "Materials/FrozenWood");
        materialFrozenWoodNode.size = CGSize(width: rawMaterialNodeSize, height: rawMaterialNodeSize);
        materialFrozenWoodNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialFrozenWoodNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialFrozenWoodNode.frame.height / 2) - rawMaterialBaseY - (rawMaterialNodeSize * 3)
        );
        materialFrozenWoodNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(materialFrozenWoodNode);
        
        
        
        materialMudLabel.text = "10";
        materialMudLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 25 + 5,
            y: GameTools.topCenterHeight - materialMudLabel.frame.height - (rawMaterialBaseY - 8)
        );
        materialMudLabel.zPosition = ZLayers.UI.rawValue;
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
        materialClayLabel.zPosition = ZLayers.UI.rawValue;
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
        materialWoodLabel.zPosition = ZLayers.UI.rawValue;
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
        materialFrozenWoodLabel.zPosition = ZLayers.UI.rawValue;
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

        GameTools.capturedLands[GameTools.mapSpawnX][GameTools.mapSpawnY].placedBuilding = CityBuilding.getCityBuilding(CityBuildingType.CityHall);
        GameTools.capturedLands[GameTools.mapSpawnX + 1][GameTools.mapSpawnY].placedBuilding = CityBuilding.getCityBuilding(CityBuildingType.CityHall);
        GameTools.capturedLands[GameTools.mapSpawnX][GameTools.mapSpawnY + 1].placedBuilding = CityBuilding.getCityBuilding(CityBuildingType.CityHall);
        GameTools.capturedLands[GameTools.mapSpawnX + 1][GameTools.mapSpawnY + 1].placedBuilding = CityBuilding.getCityBuilding(CityBuildingType.CityHall);
        GameTools.capturedLands[GameTools.mapSpawnX - 1][GameTools.mapSpawnY].placedBuilding = CityBuilding.getCityBuilding(CityBuildingType.SawMill);
        
        let cityBuildings = LandGenerator.createCityBuildings();
        for i in 0..<cityBuildings.count {
            self.addChild(cityBuildings[i]);
        }
    
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
        //cityBuildingMenuUI = CityBuildingMenuUI(self);
        //cityBuildingMenuUI.setupMenu(buildingType: CityBuildingType.Empty);
        sawMillMenuUI = SawMillMenuUI(self);
        sawMillMenuUI.setupMenu();
        
        shopButtonNode = SKSpriteNode(imageNamed: "Buttons/ShopButton");
        let shopButtonNodePositionX = GameTools.rightCenterWidth - (self.size.width / 16) - 3;
        let shopButtonNodePositionY = GameTools.bottomCenterHeight + (self.size.width / 16) + 3;
        shopButtonNode.position = CGPoint(x: shopButtonNodePositionX, y: shopButtonNodePositionY);
        shopButtonNode.size = CGSize(width: self.size.width / 8, height: self.size.width / 8);
        shopButtonNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(shopButtonNode);
        
        settingsButtonNode = SKSpriteNode(imageNamed: "Buttons/SettingsButton");
        let settingsButtonNodePositionX = GameTools.rightCenterWidth - (self.size.width / 32) - 1;
        let settingsButtonNodePositionY = GameTools.topCenterHeight - (self.size.width / 32) - 1;
        settingsButtonNode.position = CGPoint(x: settingsButtonNodePositionX, y: settingsButtonNodePositionY);
        settingsButtonNode.size = CGSize(width: self.size.width / 16, height: self.size.width / 16);
        settingsButtonNode.zPosition = ZLayers.UI.rawValue;
        self.camera?.addChild(settingsButtonNode);
        
        draggingBuildingLabel.text = "Drag to an empty tile";
        draggingBuildingLabel.position = CGPoint(x: 0, y: GameTools.bottomCenterHeight + 8);
        draggingBuildingLabel.zPosition = ZLayers.UI.rawValue;
        draggingBuildingLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5);
        draggingBuildingLabel.fontName = "ChalkboardSE-Bold";
        draggingBuildingLabel.fontSize = 28;
        draggingBuildingLabel.isHidden = true;
        self.camera?.addChild(draggingBuildingLabel);
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
    
    var movableCityBuildingNode = SKSpriteNode(color: .red, size: CGSize.zero);
    var movableCityBuildingData = CityBuilding.getCityBuilding(CityBuildingType.Empty);
    var movableCityBuildingExists = false;
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!uiOpen) {
            touchBeganPosition = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
        }
        
//        if(touches.count == 1) {
//            let touchLocation = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
//            let touchingNodes = self.nodes(at: touchLocation); //array of all the nodes that have been touched
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let totalTouchCount = event?.allTouches?.count ?? 0;
        
        if(!uiOpen) {
            if(totalTouchCount == 1) {
                let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
                
                //a city building is being dragged
                if(movableCityBuildingExists) {
                    let movePositionX = Tools.roundToStepAmount(value: location.x, stepAmount: CGFloat(GameTools.landTileSize));
                    let movePositionY = Tools.roundToStepAmount(value: location.y, stepAmount: CGFloat(GameTools.landTileSize));
                    movableCityBuildingNode.position = CGPoint(x: movePositionX, y: movePositionY);
                    
                    let landPositionX = Int(movePositionX) / GameTools.landTileSize;
                    let landPositionY = Int(movePositionY) / GameTools.landTileSize;
                    if(landPositionX > 0 && landPositionX < GameTools.mapWidth - 1 && landPositionY > 0 && landPositionY < GameTools.mapHeight - 1) {
                        let landData = GameTools.capturedLands[landPositionX][landPositionY];
                        if(landData.captured && landData.placedBuilding.buildingType == CityBuildingType.Empty) {
                            movableCityBuildingNode.color = .green;
                        }
                        else {
                            movableCityBuildingNode.color = .red;
                        }
                    }
                }
                //if a city building isn't selected then move the camera
                else {
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
        
        var buttonTouched = false; //indicates whether a button was touched (used when the land nodes shouldn't be touched)
        
        if(touches.count == 1) {
            let touchLocation = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            let touchingNodes = self.nodes(at: touchLocation); //array of all the nodes that have been touched
            let didTouchMove = (touchLocation != touchBeganPosition ? true : false); //indicates whether the touch that began and ended moved
            
            if(movableCityBuildingExists) {
                //shop button is pressed while a building is being dragged
                if(touchingNodes.contains(shopButtonNode)) {
                    movableCityBuildingExists = false;
                    self.removeChildren(in: [movableCityBuildingNode]);
                    draggingBuildingLabel.isHidden = true;
                    shopButtonNode.texture = SKTexture(imageNamed: "Buttons/ShopButton");
                    settingsButtonNode.isHidden = false;
                    buttonTouched = true;
                }
                else {
                    let landPositionX = Int(movableCityBuildingNode.position.x) / GameTools.landTileSize;
                    let landPositionY = Int(movableCityBuildingNode.position.y) / GameTools.landTileSize;
                    if(landPositionX > 0 && landPositionX < GameTools.mapWidth - 1 && landPositionY > 0 && landPositionY < GameTools.mapHeight - 1) {
                        let landData = GameTools.capturedLands[landPositionX][landPositionY];
                        if(landData.captured && landData.placedBuilding.buildingType == CityBuildingType.Empty) {
                            movableCityBuildingExists = false;
                            
                            draggingBuildingLabel.isHidden = true;
                            //shopButtonNode.isHidden = false;
                            shopButtonNode.texture = SKTexture(imageNamed: "Buttons/ShopButton");
                            settingsButtonNode.isHidden = false;
                            
                            movableCityBuildingNode.zPosition = ZLayers.PlacedCityBuilding.rawValue;
                            movableCityBuildingNode.colorBlendFactor = 0;
                            GameTools.capturedLands[landPositionX][landPositionY].placedBuilding = CityBuilding.getCityBuilding(CityBuildingType.SawMill);
                            
                            GameTools.placedBuildings.append(
                                PlacedCityBuilding(buildingData: movableCityBuildingData, position: GameVector2Int(x: landPositionX, y: landPositionY))
                            );
                            
                            let bubbles = LandGenerator.createCityBuildingBubbles();
                            print(bubbles);
                            for i in 0..<bubbles.count {
                                self.addChild(bubbles[i]);
                            }
                        }
                    }
                }
            }
            else {
                //attack menu
                if(touchingNodes.contains(attackMenuUI.buttonLabel)) {
                    GameTools.currentBattleLandType = currentAttackSelected.landType;
                    GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: currentAttackSelected.battleGeneratorData);
                    
                    Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                    return;
                }
                if(touchingNodes.contains(attackMenuUI.closeLabelBackground)) {
                    attackMenuUI.hideMenu();
                    setUiOpen(false);
                    
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
                        setUiOpen(true);
                    }
                }
                if(touchingNodes.contains(shopMenuUI.closeLabelBackground)) {
                    shopMenuUI.hideMenu();
                    setUiOpen(false);
                }
                var cityBuildingType = CityBuildingType.Empty;
                var cityBuildingName = "CityBuilding/Building";
                
                //loop through all touches detecting shop menu nodes that got clicked
                for i in 0..<touchingNodes.count {
                    let nodeName = touchingNodes[i].name;
                    
                    if(nodeName == "CityShopItem/CityHall") {
                        cityBuildingType = CityBuildingType.CityHall;
                        cityBuildingName = "CityBuilding/CityHall";
                    }
                    else if(nodeName == "CityShopItem/SawMill") {
                        cityBuildingType = CityBuildingType.SawMill;
                        cityBuildingName = "CityBuilding/SawMill";
                    }
                    else if(nodeName == "CityShopItem/DiamondMine") {
                        cityBuildingType = CityBuildingType.DiamondMine;
                        cityBuildingName = "CityBuilding/DiamondMine";
                    }
                }
                //if a building was selected from the shop menu
                if(cityBuildingType != CityBuildingType.Empty) {
                    shopMenuUI.hideMenu();
                    setUiOpen(false);

                    movableCityBuildingExists = true;
                    draggingBuildingLabel.isHidden = false;
                    //shopButtonNode.isHidden = true;
                    shopButtonNode.texture = SKTexture(imageNamed: "Buttons/CancelButton");
                    settingsButtonNode.isHidden = true;
                    let cityBuildingData = CityBuilding.getCityBuilding(cityBuildingType);
                    movableCityBuildingData = cityBuildingData;
                    
                    let newBuildingNode = SKSpriteNode(texture: cityBuildingData.texture);
                    let newNodePositionX = Tools.roundToStepAmount(value: touchLocation.x, stepAmount: CGFloat(GameTools.landTileSize));
                    let newNodePositionY = Tools.roundToStepAmount(value: touchLocation.y, stepAmount: CGFloat(GameTools.landTileSize));
                    newBuildingNode.position = CGPoint(x: newNodePositionX, y: newNodePositionY);
                    let newBuildingNodeSize = cityBuildingData.sizeTiles * GameTools.landTileSize;
                    newBuildingNode.size = CGSize(width: newBuildingNodeSize, height: newBuildingNodeSize);
                    newBuildingNode.color = .red;
                    newBuildingNode.colorBlendFactor = 0.4;
                    newBuildingNode.zPosition = ZLayers.DraggedCityBuilding.rawValue;
                    newBuildingNode.name = cityBuildingName;
                    self.addChild(newBuildingNode);
                    
                    movableCityBuildingNode = newBuildingNode;
                }
                
                //loop through all touched nodes and check if a placed building was tapped
                //this must be checked after the shop node checks to ensure you don't open the building UI while placing the building
                if(!uiOpen && !didTouchMove) {
                    for i in 0..<touchingNodes.count {
                        let nodeName = touchingNodes[i].name;
                        if(!movableCityBuildingExists) {
                            if(nodeName == "CityBuilding/CityHall") {
                                //sawMillMenuUI.showMenu();
                                //cityBuildingMenuUI.titleLabel.text = CityBuilding.getCityBuilding(CityBuildingType.CityHall).name;
                                //setUiOpen(true);
                            }
                            else if(nodeName == "CityBuilding/SawMill") {
                                sawMillMenuUI.setMenuHidden(false);
                                //sawMillMenuUI.titleLabel.text = CityBuilding.getCityBuilding(CityBuildingType.SawMill).name;
                                setUiOpen(true);
                            }
                            else if(nodeName == "CityBuilding/DiamondMine") {
                                //sawMillMenuUI.showMenu();
                                //sawMillMenuUI.titleLabel.text = CityBuilding.getCityBuilding(CityBuildingType.DiamondMine).name;
                                //setUiOpen(true);
                            }
                        }
                    }
                }
                
                for i in 0..<shopMenuUI.bodyTabLabels.count {
                    if(i != shopMenuUI.currentTabIndex && touchingNodes.contains(shopMenuUI.bodyTabLabels[i])) {
                        shopMenuUI.updateSelectedTab(i);
                    }
                }
                //settings menu
                if(touchingNodes.contains(settingsButtonNode)) {
                    if(!uiOpen) {
                        settingsMenuUI.showMenu();
                        setUiOpen(true);
                    }
                }
                if(touchingNodes.contains(settingsMenuUI.closeLabelBackground)) {
                    settingsMenuUI.hideMenu();
                    setUiOpen(false);
                }
                if(touchingNodes.contains(settingsMenuUI.saveDataButtonNode)) {
                    settingsMenuUI.saveDataButtonNode.texture = SKTexture(imageNamed: "Buttons/SavingDataButton");
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                        settingsMenuUI.saveDataButtonNode.texture = SKTexture(imageNamed: "Buttons/SaveDataButton");
                    }
                }
                
                //saw mill city building menu
                if(touchingNodes.contains(sawMillMenuUI.closeLabelBackground)) {
                    sawMillMenuUI.setMenuHidden(true);
                    setUiOpen(false);
                }
                if(touchingNodes.contains(sawMillMenuUI.woodMaterialItem)) {
                    sawMillMenuUI.setWoodTypeSelected(regular: true);
                }
                if(touchingNodes.contains(sawMillMenuUI.frozenWoodMaterialItem)) {
                    sawMillMenuUI.setWoodTypeSelected(regular: false);
                }
                if(touchingNodes.contains(sawMillMenuUI.convertLabelBackground)) {
                    if(sawMillMenuUI.canPurify) {
                        if(sawMillMenuUI.regularWoodSelected) {
                            GameTools.woodAmount -= 100;
                            GameTools.diamondAmount -= 1;
                            GameTools.planksAmount += 100;
                        }
                        else {
                            GameTools.frozenWoodAmount -= 100;
                            GameTools.diamondAmount -= 1;
                            GameTools.planksAmount += 100;
                        }
                        updateMaterialLabels();
                        sawMillMenuUI.updateResources();
                    }
                }
            }
        }

        if(!uiOpen && !movableCityBuildingExists && !buttonTouched) {
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
                            setUiOpen(true);
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
