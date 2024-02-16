//
//  GameScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import SpriteKit;
import GameplayKit;

class AttackMenuUI {
    var backgroundNode = SKShapeNode();
    var closeLabel = SKLabelNode();
    var buttonLabel = SKLabelNode();
    var titleLabel = SKLabelNode();
    var bodyLabel = SKLabelNode();
    
    var bodyMaterialLabels: [SKLabelNode] = [];
    var bodyMaterialNodes: [SKSpriteNode] = [];
    
    var scene: SKScene;
    
    init(_ scene: SKScene) {
        self.scene = scene;
    }
    
    func setupMenu() {
        backgroundNode = SKShapeNode(rect: CGRect(
            x: -scene.size.width / 1.25 / 2,
            y: -scene.size.height / 1.25 / 2,
            width: scene.size.width / 1.25,
            height: scene.size.height / 1.25
        ), cornerRadius: 14);
        backgroundNode.zPosition = 95;
        backgroundNode.lineWidth = 0;
        backgroundNode.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.8);
        backgroundNode.isHidden = true;
        scene.camera?.addChild(backgroundNode);
        
        closeLabel.position = CGPoint(x: (scene.size.width / 1.25 / 2) - 15, y: (scene.size.height / 1.25 / 2) - 30);
        closeLabel.zPosition = 100;
        closeLabel.text = "Close";
        closeLabel.fontColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1);
        closeLabel.fontName = "ChalkboardSE-Bold";
        closeLabel.fontSize = 20;
        closeLabel.horizontalAlignmentMode = .right;
        closeLabel.isHidden = true;
        scene.camera?.addChild(closeLabel);
        
        buttonLabel.position = CGPoint(x: 0, y: -scene.size.height / 3);
        buttonLabel.zPosition = 100;
        buttonLabel.text = "Start War";
        buttonLabel.fontName = "ChalkboardSE-Bold";
        buttonLabel.fontSize = 20;
        buttonLabel.isHidden = true;
        scene.camera?.addChild(buttonLabel);
        
        let buttonLabelBackground = SKShapeNode(rect: CGRect(
            x: -buttonLabel.frame.width / 2,
            y: 0,
            width: buttonLabel.frame.width,
            height: buttonLabel.frame.height
        ), cornerRadius: 5);
        buttonLabelBackground.lineWidth = 10;
        buttonLabelBackground.fillColor = GameTools.uiColor;
        buttonLabelBackground.strokeColor = GameTools.uiColor;
        buttonLabel.addChild(buttonLabelBackground);
        
        titleLabel.position = CGPoint(x: 0, y: scene.size.height / 3);
        titleLabel.zPosition = 100;
        titleLabel.text = "Battle in Greenlands";
        titleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        titleLabel.fontName = "ChalkboardSE-Bold";
        titleLabel.fontSize = 30;
        titleLabel.isHidden = true;
        scene.camera?.addChild(titleLabel);
        
//        for i in 0..<3 {
//            let materialLabel = SKLabelNode();
//            materialLabel.text = "10 000";
//            materialLabel.position = CGPoint(x: CGFloat((i - 1)) * (self.size.width / 8), y: self.size.height / 6);
//            materialLabel.zPosition = 100;
//            materialLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
//            materialLabel.fontName = "ChalkboardSE-Bold";
//            materialLabel.fontSize = 25;
//            materialLabel.horizontalAlignmentMode = .center;
//            materialLabel.isHidden = true;
//            self.camera?.addChild(materialLabel);
//            attackBodyMaterialLabels.append(materialLabel);
//        }
        
//        attackUpperBodyLabel.position = CGPoint(x: 0, y: self.size.height / 6);
//        attackUpperBodyLabel.zPosition = 100;
//        attackUpperBodyLabel.text = "Upper Body Text";
//        //attackUpperBodyLabel.numberOfLines = 3;
//        attackUpperBodyLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
//        attackUpperBodyLabel.fontName = "ChalkboardSE-Bold";
//        attackUpperBodyLabel.fontSize = 25;
//        attackUpperBodyLabel.horizontalAlignmentMode = .center;
//        attackUpperBodyLabel.isHidden = true;
//        self.camera?.addChild(attackUpperBodyLabel);
        
        bodyLabel.position = CGPoint(x: 0, y: 0);
        bodyLabel.zPosition = 100;
        bodyLabel.text = "Battle Body Text";
        bodyLabel.numberOfLines = 3;
        bodyLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
        bodyLabel.fontName = "ChalkboardSE-Bold";
        bodyLabel.fontSize = 25;
        bodyLabel.horizontalAlignmentMode = .center;
        bodyLabel.isHidden = true;
        scene.camera?.addChild(bodyLabel);
    }
    
    func showMenu(landTileData: LandTileData) {
        //remove labels and nodes from the last menu
        if(bodyMaterialNodes.count > 0) {
            scene.camera?.removeChildren(in: bodyMaterialLabels);
            scene.camera?.removeChildren(in: bodyMaterialNodes);
            
            bodyMaterialLabels = [];
            bodyMaterialNodes = [];
        }
        
        backgroundNode.isHidden = false;
        
        closeLabel.isHidden = false;
        
        buttonLabel.isHidden = false;
        titleLabel.text = "Battle in " + landTileData.landType.rawValue;
        titleLabel.isHidden = false;
        
//        attackUpperBodyLabel.isHidden = false;
//        attackUpperBodyLabel.text = """
//            Coins: 1,000   XP: 10
//        """;
        
//        for i in 0..<landTileData.materials.count {
//            attackBodyMaterialLabels[i].text = Tools.createDigitSeparatedString(landTileData.materials[i].amount, seperator: " ");
//            attackBodyMaterialLabels[i].isHidden = false;
//        }
        
        for i in 0..<landTileData.materials.count {
            let materialSize = scene.size.width / 26;
            
            let materialLabel = SKLabelNode();
            materialLabel.text = Tools.createDigitSeparatedString(landTileData.materials[i].amount, seperator: " ");
            materialLabel.position = CGPoint(
                x: CGFloat((i - 1)) * (scene.size.width / 4) + (materialSize / 2) + 4,
                y: scene.size.height / 5
            );
            materialLabel.zPosition = 100;
            materialLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
            materialLabel.fontName = "ChalkboardSE-Bold";
            materialLabel.fontSize = 25;
            materialLabel.horizontalAlignmentMode = .left;
            scene.camera?.addChild(materialLabel);
            bodyMaterialLabels.append(materialLabel);
            
            let materialNode = SKSpriteNode(imageNamed: GameTools.getMaterialAssetName(landTileData.materials[i].type));
            materialNode.size = CGSize(width: materialSize, height: materialSize);
            materialNode.position = CGPoint(
                x: CGFloat((i - 1)) * (scene.size.width / 4),
                y: (scene.size.height / 5) + materialLabel.frame.height / 2
            );
            materialNode.zPosition = 100;
            scene.camera?.addChild(materialNode);
            bodyMaterialNodes.append(materialNode);
        }
        
        let forcesType = TankData.getTank(landTileData.battleGeneratorData.forcesType);
        
        let bodyLabelText = NSMutableAttributedString(string: """
            Difficulty: \(landTileData.battleGeneratorData.difficulty)
            Type of Forces: \(forcesType.name)
        """);
        let bodyLabelColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
        let bodyValueColor = #colorLiteral(red: 0.9739930458, green: 0.7904064641, blue: 0.115796683, alpha: 1);
        bodyLabelText.addAttribute(.font, value: UIFont(name: "ChalkboardSE-Bold", size: 25) as Any, range: NSRange(location: 0, length: bodyLabelText.string.count));
        bodyLabelText.addAttribute(.foregroundColor, value: bodyLabelColor, range: NSRange(location: 0, length: bodyLabelText.string.count));
        let splitAttackBodyText = bodyLabelText.string.split(separator: "\n");
        if(splitAttackBodyText.count == 2) {
            bodyLabelText.addAttribute(
                .foregroundColor,
                value: bodyValueColor,
                range: NSString(string: bodyLabelText.string).range(of: landTileData.battleGeneratorData.difficulty.rawValue)
            );
            bodyLabelText.addAttribute(
                .foregroundColor,
                value: bodyValueColor,
                range: NSString(string: bodyLabelText.string).range(of: forcesType.name)
            );
        }
        bodyLabel.attributedText = bodyLabelText;
        bodyLabel.isHidden = false;
    }
    
    func hideMenu() {
        backgroundNode.isHidden = true;
        
        closeLabel.isHidden = true;
        
        for i in 0..<bodyMaterialLabels.count {
            bodyMaterialLabels[i].isHidden = true;
            bodyMaterialNodes[i].isHidden = true;
        }
        
        buttonLabel.isHidden = true;
        titleLabel.isHidden = true;
        bodyLabel.isHidden = true;
    }
    
}

class ShopMenuUI {
    var backgroundNode = SKShapeNode();
    var closeLabel = SKLabelNode();
    var titleLabel = SKLabelNode();
    
    var bodyTabLabels: [SKLabelNode] = [];
    
    let shopTabs: [String] = ["Production", "Defenses", "Decorations"];
    
    var scene: SKScene;
    
    init(_ scene: SKScene) {
        self.scene = scene;
    }
    
    func setupMenu() {
        backgroundNode = SKShapeNode(rect: CGRect(
            x: -scene.size.width / 1.25 / 2,
            y: -scene.size.height / 1.25 / 2,
            width: scene.size.width / 1.25,
            height: scene.size.height / 1.25
        ), cornerRadius: 14);
        backgroundNode.zPosition = 95;
        backgroundNode.lineWidth = 0;
        backgroundNode.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.8);
        backgroundNode.isHidden = true;
        scene.camera?.addChild(backgroundNode);
        
        closeLabel.position = CGPoint(x: (scene.size.width / 1.25 / 2) - 15, y: (scene.size.height / 1.25 / 2) - 30);
        closeLabel.zPosition = 100;
        closeLabel.text = "Close";
        closeLabel.fontColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1);
        closeLabel.fontName = "ChalkboardSE-Bold";
        closeLabel.fontSize = 20;
        closeLabel.horizontalAlignmentMode = .right;
        closeLabel.isHidden = true;
        scene.camera?.addChild(closeLabel);
        
        titleLabel.position = CGPoint(x: 0, y: scene.size.height / 3);
        titleLabel.zPosition = 100;
        titleLabel.text = "City Shop";
        titleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        titleLabel.fontName = "ChalkboardSE-Bold";
        titleLabel.fontSize = 30;
        titleLabel.isHidden = true;
        scene.camera?.addChild(titleLabel);
        
        for i in 0..<shopTabs.count {
            let tabLabel = SKLabelNode();
            tabLabel.text = shopTabs[i];
            tabLabel.position = CGPoint(
                x: CGFloat((i - 1)) * (scene.size.width / 4) + 4,
                y: scene.size.height / 5
            );
            tabLabel.zPosition = 100;
            tabLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
            tabLabel.fontName = "ChalkboardSE-Bold";
            tabLabel.fontSize = 25;
            tabLabel.horizontalAlignmentMode = .center;
            tabLabel.isHidden = true;
            scene.camera?.addChild(tabLabel);
            bodyTabLabels.append(tabLabel);
        }
    }
    
    func showMenu() {
        backgroundNode.isHidden = false;
        closeLabel.isHidden = false;
        titleLabel.isHidden = false;
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].isHidden = false;
        }
    }
    
    func hideMenu() {
        backgroundNode.isHidden = true;
        closeLabel.isHidden = true;
        titleLabel.isHidden = true;
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].isHidden = true;
        }
    }
}

class GameScene: SKScene {
    
    var cameraNode = SKCameraNode();
    
    var lastTouch: CGPoint?; //the point of where the last touch happened. nil if there isn't any touches
    var uiOpen = false;
    
    let minCameraScale: CGFloat = 0.5; //the minimum you can zoom the camera out
    let maxCameraScale: CGFloat = 15; //the maximum you can zoom the camera out/
    
    
    var materialBrickLabel = SKLabelNode();
    var materialPlanksLabel = SKLabelNode();
    var materialDiamondLabel = SKLabelNode();
    
    var materialBrickNode = SKSpriteNode();
    var materialPlanksNode = SKSpriteNode();
    var materialDiamondNode = SKSpriteNode();
    
    var attackMenuUI: AttackMenuUI!;
//    var attackBackgroundNode = SKShapeNode();
//    var attackCloseLabel = SKLabelNode();
//    var attackButtonLabel = SKLabelNode();
//    var attackTitleLabel = SKLabelNode();
//    var attackBodyLabel = SKLabelNode();
//    
//    var attackBodyMaterialLabels: [SKLabelNode] = [];
//    var attackBodyMaterialNodes: [SKSpriteNode] = [];
    
    var currentAttackSelected = LandTileData();
    
    
    
    var shopButtonNode = SKSpriteNode();
    
    var shopBackgroundNode = SKShapeNode();
    var shopCloseLabel = SKLabelNode();
    var shopTitleLabel = SKLabelNode();
    
    var shopBodyTabLabels: [SKLabelNode] = [];
    
    let shopTabs: [String] = ["Production", "Defenses", "Decorations"];
    var shopMenuUI: ShopMenuUI!;
    
    
    
    var settingsButtonNode = SKSpriteNode();
    
    var settingsBackgroundNode = SKShapeNode();
    var settingsCloseLabel = SKLabelNode();
    var settingsTitleLabel = SKLabelNode();
    
    

    
    //creates the material label nodes
    func setupMaterialLabels() {
        materialBrickNode = SKSpriteNode(imageNamed: "Materials/Brick");
        materialBrickNode.size = CGSize(width: 40, height: 40);
        materialBrickNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialBrickNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialBrickNode.frame.height / 2)
        );
        materialBrickNode.zPosition = 100;
        self.camera?.addChild(materialBrickNode);
        
        materialPlanksNode = SKSpriteNode(imageNamed: "Materials/Planks");
        materialPlanksNode.size = CGSize(width: 40, height: 40);
        materialPlanksNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialPlanksNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialPlanksNode.frame.height / 2) - 35
        );
        materialPlanksNode.zPosition = 100;
        self.camera?.addChild(materialPlanksNode);

        materialDiamondNode = SKSpriteNode(imageNamed: "Materials/Diamond");
        materialDiamondNode.size = CGSize(width: 40, height: 40);
        materialDiamondNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (materialDiamondNode.frame.width / 2),
            y: GameTools.topCenterHeight - (materialDiamondNode.frame.height / 2) - 70
        );
        materialDiamondNode.zPosition = 100;
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
    

    
    func setupSettingsMenu() {
        settingsBackgroundNode = SKShapeNode(rect: CGRect(
            x: -self.size.width / 1.25 / 2,
            y: -self.size.height / 1.25 / 2,
            width: self.size.width / 1.25,
            height: self.size.height / 1.25
        ), cornerRadius: 14);
        settingsBackgroundNode.zPosition = 95;
        settingsBackgroundNode.lineWidth = 0;
        settingsBackgroundNode.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.8);
        settingsBackgroundNode.isHidden = true;
        self.camera?.addChild(settingsBackgroundNode);
        
        settingsCloseLabel.position = CGPoint(x: (self.size.width / 1.25 / 2) - 15, y: (self.size.height / 1.25 / 2) - 30);
        settingsCloseLabel.zPosition = 100;
        settingsCloseLabel.text = "Close";
        settingsCloseLabel.fontColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1);
        settingsCloseLabel.fontName = "ChalkboardSE-Bold";
        settingsCloseLabel.fontSize = 20;
        settingsCloseLabel.horizontalAlignmentMode = .right;
        settingsCloseLabel.isHidden = true;
        self.camera?.addChild(settingsCloseLabel);
        
        settingsTitleLabel.position = CGPoint(x: 0, y: self.size.height / 3);
        settingsTitleLabel.zPosition = 100;
        settingsTitleLabel.text = "City Settings";
        settingsTitleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        settingsTitleLabel.fontName = "ChalkboardSE-Bold";
        settingsTitleLabel.fontSize = 30;
        settingsTitleLabel.isHidden = true;
        self.camera?.addChild(settingsTitleLabel);
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
        //setupAttackMenu();
        //setupShopMenu();
        shopMenuUI = ShopMenuUI(self);
        shopMenuUI.setupMenu();
        setupSettingsMenu();
        
        shopButtonNode = SKSpriteNode(imageNamed: "ShopButton");
        let shopButtonNodePositionX = GameTools.rightCenterWidth - (self.size.width / 16) - 3;
        let shopButtonNodePositionY = GameTools.bottomCenterHeight + (self.size.width / 16) + 3;
        shopButtonNode.position = CGPoint(x: shopButtonNodePositionX, y: shopButtonNodePositionY);
        shopButtonNode.size = CGSize(width: self.size.width / 8, height: self.size.width / 8);
        shopButtonNode.zPosition = 90;
        self.camera?.addChild(shopButtonNode);
        
        settingsButtonNode = SKSpriteNode(imageNamed: "SettingsButton");
        let settingsButtonNodePositionX = GameTools.rightCenterWidth - (self.size.width / 32) - 1;
        let settingsButtonNodePositionY = GameTools.topCenterHeight - (self.size.width / 32) - 1;
        settingsButtonNode.position = CGPoint(x: settingsButtonNodePositionX, y: settingsButtonNodePositionY);
        settingsButtonNode.size = CGSize(width: self.size.width / 16, height: self.size.width / 16);
        settingsButtonNode.zPosition = 90;
        self.camera?.addChild(settingsButtonNode);
    }
    
    @objc func swipeGestureAction(_ sender: UISwipeGestureRecognizer) {
        if(uiOpen) {
            if(sender.direction == .up || sender.direction == .down) {
                let swipeLocation = sender.location(in: sender.view);
                let swipeViewLocation = self.convertPoint(fromView: swipeLocation);
                let swipedNodes = self.atPoint(swipeViewLocation);
                
                if(swipedNodes.contains(shopBackgroundNode)) {
                    print("SWIPED!");
                }
            }
        }
    }
    
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
            
            if(touchingNodes.contains(attackMenuUI.buttonLabel)) {
                GameTools.currentBattleLandType = currentAttackSelected.landType;
                GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: currentAttackSelected.battleGeneratorData);
                
                Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                return;
            }
            if(touchingNodes.contains(attackMenuUI.closeLabel)) {
                attackMenuUI.hideMenu();
                uiOpen = false;
            }
            if(touchingNodes.contains(shopButtonNode)) {
                if(!uiOpen) {
                    shopMenuUI.showMenu();
                    uiOpen = true;
                }
            }
            if(touchingNodes.contains(shopMenuUI.closeLabel)) {
                shopMenuUI.hideMenu();
                uiOpen = false;
            }
            if(touchingNodes.contains(settingsButtonNode)) {
                uiOpen = true;
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
                            
                            GameTools.capturedLands[posX][posY].captured = true;

                            GameTools.borderNodesParent.removeAllChildren();
                            let borderNodes = LandGenerator.generateCapturedBorders();
                            
                            for k in 0..<borderNodes.count {
                                GameTools.borderNodesParent.addChild(borderNodes[k]);
                            }
                            
                            print(GameTools.capturedLands[posX][posY].battleGeneratorData);
                            GameTools.currentBattleLandType = GameTools.capturedLands[posX][posY].landType;
                            GameTools.currentBattleData = BattleGenerator.getFixedBattle(generatorData: GameTools.capturedLands[posX][posY].battleGeneratorData);
                            
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
