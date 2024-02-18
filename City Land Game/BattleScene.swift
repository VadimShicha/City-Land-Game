//
//  BattleScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/20/24.
//

import Foundation;
import SpriteKit;

//struct for holding all the data for the defenses you could use
struct TankData {
    var name: String = "Tank";
    var sizeTiles: Int = 3;
    var baseHealth: Int = 100;
    var metal: Int = 3;
    var texture = SKTexture();
    
    static func getTank(_ tank: TankDataEnum) -> TankData {
        switch(tank.rawValue) {
            case 0:
                return TankData(name: "Green Tank", sizeTiles: 3, baseHealth: 50, metal: 2, texture: SKTexture(imageNamed: "Tanks/Jet"))
            case 1:
                return TankData(name: "Tan Tank", sizeTiles: 3, baseHealth: 100, metal: 4, texture: SKTexture(imageNamed: "Tanks/TanTank"))
            case 2:
                return TankData(name: "Red Tank", sizeTiles: 3, baseHealth: 500, metal: 6, texture: SKTexture(imageNamed: "Tanks/RedTank"))
            case 3:
                return TankData(name: "Blue Tank", sizeTiles: 3, baseHealth: 1000, metal: 10, texture: SKTexture(imageNamed: "Tanks/BlueTank"))
            default:
                return getTank(TankDataEnum.GreenTank);
        }
    }
}

enum TankDataEnum: Int, CaseIterable {
    case GreenTank = 0
    case TanTank = 1
    case RedTank = 2
    case BlueTank = 3
}

//struct for holding all the data for the defenses you could use
struct DefenseData {
    var name: String = "Defense";
    var sizeTiles: Int = 3;
    var targetRadius: CGFloat = 3;
    var attackDamage = 50; //amount of damage each attack does
    var attackSpeed = 1; //attack speed per second
    var cost: Int = 100;
    var texture = SKTexture();
    
    var lastAttackTime: TimeInterval = 0;
    
    static func getDefense(_ defense: DefenseDataEnum) -> DefenseData {
        switch(defense.rawValue) {
            case 0:
                return DefenseData(name: "Catapult", sizeTiles: 3, targetRadius: 8, attackDamage: 50, cost: 100, texture: SKTexture(imageNamed: "Defenses/Catapult"));
            case 1:
                return DefenseData(name: "Cannon", sizeTiles: 3, targetRadius: 5, attackDamage: 100, cost: 250, texture: SKTexture(imageNamed: "Defenses/Cannon"))
            default:
                return getDefense(DefenseDataEnum.Catapult);
        }
    }
}

enum DefenseDataEnum: Int, CaseIterable {
    case Catapult = 0
    case Cannon = 1
}

struct PlacedDefense {
    var node = SKSpriteNode();
    var defenseData = DefenseData.getDefense(DefenseDataEnum.Catapult);
}

class BattleScene: SKScene {
    var cameraNode = SKCameraNode();
    
    enum ZLayers: CGFloat, CaseIterable {
        case SceneBackground = -50
        case Tank = 40
        case PlacedDefense = 45
        case BattleHall = 47
        case ItemMenuBackground = 50
        case ItemMenuItem = 55
        case DraggedDefenseRadius = 59
        case DraggedDefense = 60
        case UI = 100
    }
    
    enum SoundEffectType: Int, CaseIterable {
        case CatapultFire = 0
        case CannonFire = 1
    }
    
    let greenMenuItemColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1);
    let redMenuItemColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1);
    
    let defenseRadiusColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.503757399);
    
    var metalAmountLabel = SKLabelNode();
    var roundAmountLabel = SKLabelNode();
    var roundPercentLabel = SKLabelNode();
    var metalAmount = 1000;
    
    var addDefenseParent = SKSpriteNode();
    var addDefenseBackgroundNodes: [SKShapeNode] = [];
    var addDefenseNodes: [SKSpriteNode] = [];
    
    var spawnTankParent = SKSpriteNode();
    var spawnTankNodes: [SKSpriteNode] = [];
    
    var placedDefenses: [PlacedDefense] = []; //array of all the placed defenses
    
    var addDefenseButton = SKSpriteNode(); //button to open the defense menu
    var spawnTankButton = SKSpriteNode(); //button to open the tank menu
    var playButton = SKSpriteNode(); //button to start the next round
    var settingsButton = SKSpriteNode(); //button to open the battle settings menu
    
    var battleHallNode = SKSpriteNode();
    
    var isPlaying = false; //state of the battle
    
    var defenseRadiusNode = SKShapeNode(); //the node used to show the range of the movable defense node
    
    //the defenses that are available to the user
    let availableDefenses: [DefenseData] = [
        DefenseData.getDefense(DefenseDataEnum.Catapult),
        DefenseData.getDefense(DefenseDataEnum.Cannon)
    ];
    
    let availableTanks: [TankData] = [
        TankData.getTank(TankDataEnum.GreenTank),
        TankData.getTank(TankDataEnum.TanTank),
        TankData.getTank(TankDataEnum.RedTank),
        TankData.getTank(TankDataEnum.BlueTank)
    ];
    
    var tileSize: CGFloat = 0; //size of each tile based on screen size
    
    var stonePathTiles: [SKSpriteNode] = []; //array of the stone path nodes that tanks travel on
    var stonePathTilesParent = SKSpriteNode(); //parent of the stone path nodes
    
    //checks if two frames are inside of each other (touching each other)
    //tolerance is an optional argument that allowes the frames to be touching by that value (default is 0, none)
    func framesTouching(frame1: CGRect, frame2: CGRect, tolerance: CGFloat = 0) -> Bool {
        let xDistance = abs(frame1.midX - frame2.midX);
        let yDistance = abs(frame1.midY - frame2.midY);
        
        let framesXWidth = (frame1.width / 2) + (frame2.width / 2);
        let framesXHeight = (frame1.height / 2) + (frame2.height / 2);
        
        if(xDistance <= framesXWidth - tolerance && yDistance <= framesXHeight - tolerance) { return true; }
        return false;
    }
    
    //returns the distance between two points
    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let xDistanceSqrd = pow(point2.x - point1.x, 2);
        let yDistanceSqrd = pow(point2.y - point1.y, 2);

        return sqrt(xDistanceSqrd + yDistanceSqrd);
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
    func addMetalLabel() {
        var textColor = UIColor.white;
        if(GameTools.currentBattleLandType == BattleLandType.SnowyFields || GameTools.currentBattleLandType == BattleLandType.Sand) {
            textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        }
        
        let metalNode = SKSpriteNode(imageNamed: "Metal");
        metalNode.size = CGSize(width: self.size.width / 15, height: self.size.width / 15);
        metalNode.position = CGPoint(
            x: GameTools.leftCenterWidth + (self.size.width / 30),
            y: GameTools.topCenterHeight - (self.size.height / 30)
        );
        metalNode.zPosition = ZLayers.UI.rawValue;
        self.addChild(metalNode);
        
        metalAmountLabel = SKLabelNode(text: String(metalAmount));
        metalAmountLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + (self.size.width / 15) + 5,
            y: GameTools.topCenterHeight - metalAmountLabel.frame.height - 3
        );
        metalAmountLabel.zPosition = ZLayers.UI.rawValue;
        metalAmountLabel.horizontalAlignmentMode = .left;
        metalAmountLabel.fontName = "ChalkboardSE-Bold";
        metalAmountLabel.fontSize = 20;
        metalAmountLabel.fontColor = textColor;
        self.addChild(metalAmountLabel);
    }
    
    //adds the text that keeps track of the rounds
    func addRoundLabel() {
        roundAmountLabel = SKLabelNode(text: "Round 0 of 0");
        roundAmountLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 5,
            y: GameTools.topCenterHeight - metalAmountLabel.frame.height - roundAmountLabel.frame.height - 6
        );
        roundAmountLabel.zPosition = ZLayers.UI.rawValue;
        roundAmountLabel.horizontalAlignmentMode = .left;
        roundAmountLabel.fontName = "ChalkboardSE-Bold";
        roundAmountLabel.fontSize = 16;
        roundAmountLabel.fontColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
        self.addChild(roundAmountLabel);
        updateRoundLabel();
        
        roundPercentLabel = SKLabelNode(text: "0%");
        roundPercentLabel.position = CGPoint(
            x: GameTools.leftCenterWidth + 5,
            y: GameTools.topCenterHeight - metalAmountLabel.frame.height - roundAmountLabel.frame.height - roundPercentLabel.frame.height - 7
        );
        roundPercentLabel.zPosition = ZLayers.UI.rawValue;
        roundPercentLabel.horizontalAlignmentMode = .left;
        roundPercentLabel.fontName = "ChalkboardSE-Bold";
        roundPercentLabel.fontSize = 14;
        roundPercentLabel.fontColor = #colorLiteral(red: 0.7732875163, green: 0.7732875163, blue: 0.7732875163, alpha: 1);
        self.addChild(roundPercentLabel);
        updateRoundTanksLabel();
    }
    
    //updates the round number text
    func updateRoundLabel() {
        roundAmountLabel.text = "Round " + String(GameTools.currentBattleRound + 1) + " of " + String(GameTools.currentBattleData.roundAmount);
    }
    
    func updateRoundTanksLabel() {
        if(currentTankIndex != 0) {
            roundPercentLabel.text = String(currentTankIndex) + " of " + String(currentRoundTanks.count) + " tanks";
        }
        else {
            roundPercentLabel.text = "";
        }
    }
    
    func addPlayRoundButton() {
        let nodeSize = self.size.width / 16;
        playButton = SKSpriteNode(imageNamed: "Buttons/PlayButton");
        playButton.size = CGSize(width: nodeSize, height: nodeSize);
        
        let buttonPosX = GameTools.rightCenterWidth - (nodeSize / 2);
        let buttonPosY = GameTools.topCenterHeight - (nodeSize / 2);
        
        playButton.position = CGPoint(x: buttonPosX - 5, y: buttonPosY - 5);
        playButton.zPosition = ZLayers.UI.rawValue;
        self.addChild(playButton);
    }
    
    func addSettingsButton() {
        let nodeSize = self.size.width / 16;
        settingsButton = SKSpriteNode(imageNamed: "Buttons/SettingsButton");
        settingsButton.size = CGSize(width: nodeSize, height: nodeSize);
        
        let buttonPosX = GameTools.rightCenterWidth - (nodeSize / 2);
        let buttonPosY = GameTools.bottomCenterHeight + (nodeSize / 2);
        
        settingsButton.position = CGPoint(x: buttonPosX - 5, y: buttonPosY + 5);
        settingsButton.zPosition = ZLayers.UI.rawValue;
        self.addChild(settingsButton);
    }
    
    func createDefenseNode(nodeSize: CGFloat, defenseData: DefenseData, position: CGPoint) {
        
        let defenseNode = SKSpriteNode(texture: defenseData.texture);
        defenseNode.size = CGSize(width: nodeSize - 10, height: nodeSize - 10);
        defenseNode.zPosition = 95;

        defenseNode.position = CGPoint(
            x: position.x + 5,
            y: position.y + 5 + 4
        );
        
        addDefenseNodes.append(defenseNode);
        addDefenseParent.addChild(defenseNode);
        
        let defenseBackgroundNode = SKShapeNode(rect: CGRect(
            x: position.x + 5 - (nodeSize / 2),
            y: position.y + 5 - (nodeSize / 2),
            width: nodeSize,
            height: nodeSize
        ), cornerRadius: 6);
        defenseBackgroundNode.lineWidth = 0;
        defenseBackgroundNode.fillColor = (metalAmount >= defenseData.cost ? greenMenuItemColor : redMenuItemColor);
        defenseBackgroundNode.zPosition = ZLayers.ItemMenuBackground.rawValue;
        addDefenseBackgroundNodes.append(defenseBackgroundNode);
        addDefenseParent.addChild(defenseBackgroundNode);
        
        let metalLabel = SKLabelNode(text: String(defenseData.cost));
        metalLabel.position = CGPoint(
            x: position.x + 5,
            y: position.y + 5 - (nodeSize / 2) + 1
        );
        metalLabel.zPosition = ZLayers.UI.rawValue;
        metalLabel.horizontalAlignmentMode = .center;
        metalLabel.fontName = "ChalkboardSE-Bold";
        metalLabel.fontSize = 12;
        addDefenseParent.addChild(metalLabel);
    }
    
    func updateDefenseMenu() {
        for i in 0..<addDefenseBackgroundNodes.count {
            addDefenseBackgroundNodes[i].fillColor = (metalAmount >= availableDefenses[i].cost ? greenMenuItemColor : redMenuItemColor);
        }
    }
    
    //updates the texture of the play button based on the game state
    func updatePlayButton() {
        playButton.texture = (isPlaying ? SKTexture(imageNamed: "Buttons/PlayingButton") : SKTexture(imageNamed: "Buttons/PlayButton"));
    }
    
    func addDefenseMenu() {
        let nodeSize = self.size.width / 16;
        addDefenseButton = SKSpriteNode(imageNamed: "Buttons/AddButton");
        addDefenseButton.size = CGSize(width: nodeSize, height: nodeSize);
        
        let buttonPosX = GameTools.leftCenterWidth + (nodeSize / 2);
        let buttonPosY = GameTools.bottomCenterHeight + (nodeSize / 2);
        
        addDefenseButton.position = CGPoint(x: buttonPosX + 5, y: buttonPosY + 5);
        addDefenseButton.zPosition = ZLayers.UI.rawValue;
        self.addChild(addDefenseButton);

        //display all the dragable defenses
        for i in 0..<availableDefenses.count {
            let nodePosXOffset = i * (Int(nodeSize) + 5);
            let nodePosX = nodePosXOffset + Int((nodeSize * 1.5)) + 5;
            let nodePosY = nodeSize / 2;
            
            createDefenseNode(nodeSize: nodeSize, defenseData: availableDefenses[i], position: CGPoint(
                x: GameTools.leftCenterWidth + CGFloat(nodePosX),
                y: GameTools.bottomCenterHeight + nodePosY
            ));
            
        }
        
        let addDefenseBackgroundNode = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: nodeSize + 10));
        addDefenseBackgroundNode.position = CGPoint(
            x: 0,
            y: GameTools.bottomCenterHeight + (nodeSize / 2) + 5
        );
        addDefenseBackgroundNode.zPosition = ZLayers.ItemMenuBackground.rawValue;
        //addDefenseParent.addChild(addDefenseBackgroundNode);
        
        addDefenseParent.isHidden = true;
        self.addChild(addDefenseParent);
    }
    
    //generate the stone path where attacks come from
    func addTankPathTiles() {
        var pathImageName = "BattlePathTiles/StonePathTile";
        
        switch(GameTools.currentBattleLandType) {
            case BattleLandType.GrassLands:
                pathImageName = "BattlePathTiles/StonePathTile";
                break;
            case BattleLandType.Sand:
                pathImageName = "BattlePathTiles/SandPathTile";
                break;
            case BattleLandType.Ocean:
                pathImageName = "BattlePathTiles/WaterPathTile";
                break;
            default:
                break;
        }
        
        for i in -15...15 {
            let stonePathTile = SKSpriteNode(imageNamed: pathImageName);
            stonePathTile.size = CGSize(width: tileSize * 2, height: tileSize * 2);
            stonePathTile.position = CGPoint(x: i * Int(tileSize) * 2, y: 0);
            stonePathTiles.append(stonePathTile);
            stonePathTilesParent.addChild(stonePathTile);
        }
        self.addChild(stonePathTilesParent);
    }
    
    //add the background node to the scene
    func addBackgroundNode() {
        
        var backgroundImageName = "";
        
        switch(GameTools.currentBattleLandType) {
            case BattleLandType.GrassLands:
                backgroundImageName = "BattleBackgrounds/GrassLandBackground";
                break;
            case BattleLandType.Sand:
                backgroundImageName = "BattleBackgrounds/SandLandBackground";
                break;
            case BattleLandType.Ocean:
                backgroundImageName = "BattleBackgrounds/OceanLandBackground";
                break;
            case BattleLandType.SnowyFields:
                backgroundImageName = "BattleBackgrounds/SnowLandBackground";
                break;
            case BattleLandType.CannonValley:
                backgroundImageName = "BattleBackgrounds/CannonValleyBackground";
                break;
            default:
                backgroundImageName = "BattleBackgrounds/GrassLandBackground";
                break;
        }
        
        let backgroundNode = SKSpriteNode(imageNamed: backgroundImageName);
        backgroundNode.size = CGSize(width: self.size.height * 2, height: self.size.height);
        backgroundNode.position = CGPoint.zero;
        backgroundNode.zPosition = ZLayers.SceneBackground.rawValue;
        self.addChild(backgroundNode);
    }
    
    //adds the background grid nodes to the scene
    func addBackgroundGrid() {
        //let lightTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 15 / 255);
        //let darkTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 45 / 255);
        
        var lightColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.05);
        var darkColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.18);
        
        switch(GameTools.currentBattleLandType) {
            case BattleLandType.Sand:
                lightColor = #colorLiteral(red: 0.750787807, green: 0.7548250808, blue: 0.6804467487, alpha: 0.05);
                darkColor = #colorLiteral(red: 0.750787807, green: 0.7548250808, blue: 0.6804467487, alpha: 0.14);
                break;
            case BattleLandType.Ocean:
                lightColor = #colorLiteral(red: 0.2572673366, green: 0.5381632205, blue: 0.7548250808, alpha: 0.05);
                darkColor = #colorLiteral(red: 0.2572673366, green: 0.5381632205, blue: 0.7548250808, alpha: 0.18);
                break;
            default:
                break;
        }
        
        var lightColorGridTile = true;
        
        for y in -7...7 {
            if(y == -1 || y == 0 || y == 1) { continue; }
            for x in -14...14 {
                let gridTileNode = SKSpriteNode(
                    color: lightColorGridTile ? lightColor : darkColor,
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
    
    func addBattleHall() {
        battleHallNode = SKSpriteNode(imageNamed: "BattleHalls/BattleHall");
        battleHallNode.colorBlendFactor = 0.2;
        battleHallNode.size = CGSize(width: tileSize * 6, height: tileSize * 6);
        battleHallNode.position = CGPoint(x: self.size.width / 2 - (tileSize * 1.5), y: tileSize * 1.5);
        battleHallNode.zPosition = ZLayers.BattleHall.rawValue;
        self.addChild(battleHallNode);
    }
    
    func updateBattleHall() {
        switch(GameTools.currentBattleLives) {
            case 3:
                battleHallNode.texture = SKTexture(imageNamed: "BattleHalls/BattleHall");
                break;
            case 2:
                battleHallNode.texture = SKTexture(imageNamed: "BattleHalls/BattleHallBroken1");
                break;
            case 1:
                battleHallNode.texture = SKTexture(imageNamed: "BattleHalls/BattleHallBroken2");
                break;
            default:
                battleHallNode.texture = SKTexture(imageNamed: "BattleHalls/BattleHallBroken3");
                break;
        }
    }
    
    func addTankSpawnMenu() {
        let negativeCenterWidth = -(self.size.width / 2);
        let negativeCenterHeight = -(self.size.height / 2);
        
        let nodeSize = self.size.width / 16;
        spawnTankButton = SKSpriteNode(imageNamed: "Buttons/TankButton");
        spawnTankButton.size = CGSize(width: nodeSize, height: nodeSize);
        
        let spawnTankButtonPositionX = negativeCenterWidth + (nodeSize / 2);
        let spawnTankButtonPositionY = negativeCenterHeight + (nodeSize / 2);
        
        spawnTankButton.position = CGPoint(x: spawnTankButtonPositionX + 5, y: spawnTankButtonPositionY + 5 + nodeSize + 5);
        spawnTankButton.zPosition = ZLayers.UI.rawValue;
        self.addChild(spawnTankButton);

        //display all the clickable tanks
        for i in 0..<availableTanks.count {
            let tankNode = SKSpriteNode(texture: availableTanks[i].texture)
            tankNode.size = CGSize(width: nodeSize, height: nodeSize);
            tankNode.zPosition = ZLayers.ItemMenuItem.rawValue;
            let tankNodeWidth = CGFloat(i * (Int(nodeSize) + 5));
            
            let tankNodePositionX = negativeCenterWidth + tankNodeWidth + (nodeSize * 1.5);
            let tankNodePositionY = negativeCenterHeight + (nodeSize / 2);
            
            tankNode.position = CGPoint(
                x: tankNodePositionX + 5 + 5,
                y: tankNodePositionY + 5
            );
            
            spawnTankNodes.append(tankNode);
            spawnTankParent.addChild(tankNode);
            
            let nodePosXOffset = i * (Int(nodeSize) + 5);
            let nodePosX = nodePosXOffset + Int((nodeSize * 1.5)) + 5;
            let nodePosY = nodeSize / 2;
            
            let tankBackgroundNode = SKShapeNode(rect: CGRect(
                x: GameTools.leftCenterWidth + CGFloat(nodePosX + 5) - (nodeSize / 2),
                y: GameTools.bottomCenterHeight + nodePosY + 5 - (nodeSize / 2),
                width: nodeSize,
                height: nodeSize
            ), cornerRadius: 6);
            tankBackgroundNode.lineWidth = 0;
            tankBackgroundNode.fillColor = .brown;
            tankBackgroundNode.zPosition = ZLayers.ItemMenuBackground.rawValue;
            spawnTankParent.addChild(tankBackgroundNode);
        }
        
//        let spawnTankBackgroundNode = SKSpriteNode(color: .brown, size: CGSize(width: self.size.width, height: spawnTankButtonSize + 10));
//        spawnTankBackgroundNode.position = CGPoint(
//            x: 0,
//            y: negativeCenterHeight + (spawnTankButtonSize / 2) + 5
//        );
//        spawnTankBackgroundNode.zPosition = ZLayers.ItemMenuBackground.rawValue;
        //spawnTankParent.addChild(spawnTankBackgroundNode);
        
        spawnTankParent.isHidden = true;
        self.addChild(spawnTankParent);
    }
    
    //sets the amount of metal the user has with a UI update
    func setMetalAmount(_ value: Int) {
        metalAmount = value;
        metalAmountLabel.text = String(value);
    }
    
    //plays a sound effect based on the SoundEffectType enum
    func playSoundEffect(_ soundEffectType: SoundEffectType) {
        var soundNames: [String] = []; //array of all the names of the sound effects
        var delayBetweenSounds: CGFloat = 0.2; //the delay between each sound (only matters when there is more than 1)
        
        switch(soundEffectType) {
            case SoundEffectType.CatapultFire:
                soundNames = ["Wind.mp3", "CatapultFire.mp3"];
                delayBetweenSounds = 0.2;
                break;
            case SoundEffectType.CannonFire:
                soundNames = ["CannonFire.mp3"];
                break;
        }
        
        if(soundNames.count == 0) { return; } //don't play a sound if a SoundEffectType wasn't provided
        
        cameraNode.run(SKAction.playSoundFileNamed(soundNames[0], waitForCompletion: false)); //play the first sound instantly
        
        //play the next sounds based on the delay between sounds variable
        for i in 1..<soundNames.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (CGFloat(i) * delayBetweenSounds)) { [self] in
                cameraNode.run(SKAction.playSoundFileNamed(soundNames[i], waitForCompletion: false));
            }
        }
    }
    
    //finds the nearest tank to a placed defense. If none could be found -1 is returned
    func findNearestTankToDefense(defense: PlacedDefense, checkDefenseRadius: Bool) -> Int {
        var shortestDistance: CGFloat = -1;
        var shortestDistanceTankIndex = -1;
        
        for i in 0..<currentRoundTanks.count {
            //if the tank is broken don't check it
            if(currentRoundTanks[i].health <= 0 || !currentRoundTanks[i].spawned) { continue; }
            
            //distance between the defense and tank based on center point
            let distance = distanceBetweenPoints(defense.node.position, currentRoundTanks[i].node.position);
            //distance between the defense and tank accounting for the node sizes
            let newDistance = distance - (defense.node.size.width / 2) - (currentRoundTanks[i].node.size.width / 2)
            
            if(checkDefenseRadius && newDistance > defense.defenseData.targetRadius * tileSize) { continue; }
            
            if(shortestDistance == -1 || newDistance < shortestDistance) {
                shortestDistance = newDistance;
                shortestDistanceTankIndex = i;
            }
        }
        
        return shortestDistanceTankIndex;
    }
    
    override func didMove(to view: SKView) {
        tileSize = CGFloat(self.size.width / 30);
        
        addBackgroundNode();
        //addBackgroundGrid();
        addTankPathTiles();
        
        addBattleHall();
        
        addMetalLabel();
        addRoundLabel();
        addPlayRoundButton();
        addSettingsButton();
        
        addDefenseMenu();
        //addTankSpawnMenu();
        
        GameTools.currentBattleRound = -1;
        
        defenseRadiusNode = SKShapeNode(circleOfRadius: 50);
        defenseRadiusNode.zPosition = ZLayers.DraggedDefense.rawValue;
        
        defenseRadiusNode.isHidden = true;
        self.addChild(defenseRadiusNode);
        
        cameraNode.position = CGPoint.zero;
        self.camera = cameraNode;
        self.addChild(cameraNode);
    }
    
    var movableDefenseNode = SKSpriteNode(); //the defense that could
    var moveableDefenseNodeExists = false; //is there a defense that is currently movable
    
    var movableDefenseData = DefenseData(); //data of the currently movable defense
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.count == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            for i in 0..<addDefenseNodes.count {
                if(self.nodes(at: location).contains(addDefenseNodes[i])) {
                    if(metalAmount < availableDefenses[i].cost) { break; } //if the defense can't be afforded, break out
                    movableDefenseData = availableDefenses[i];
                    movableDefenseNode = addDefenseNodes[i].copy() as! SKSpriteNode;
                    let movableDefenseNodeSize = tileSize * CGFloat(availableDefenses[i].sizeTiles);
                    movableDefenseNode.size = CGSize(width: movableDefenseNodeSize, height: movableDefenseNodeSize);
                    moveableDefenseNodeExists = true;
                    self.addChild(movableDefenseNode);
                    
                    setMetalAmount(metalAmount - availableDefenses[i].cost);
                    
                    setAddDefenseMenuHidden(true);
                }
            }
            
            for i in 0..<spawnTankNodes.count {
                if(self.nodes(at: location).contains(spawnTankNodes[i])) {
                    let tank = SKSpriteNode(texture: availableTanks[i].texture);
                    tank.position = CGPoint(x: -(self.size.width / 2), y: 10);
                    tank.size = CGSize(width: (Int(tileSize) * availableTanks[i].sizeTiles) + 16, height: (Int(tileSize) * availableTanks[i].sizeTiles) + 16);
                    tank.zPosition = ZLayers.Tank.rawValue;
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
            
            self.removeChildren(in: [defenseRadiusNode]);
            defenseRadiusNode = SKShapeNode(circleOfRadius: tileSize * movableDefenseData.targetRadius);
            defenseRadiusNode.fillColor = defenseRadiusColor;
            defenseRadiusNode.lineWidth = 0;
            defenseRadiusNode.zPosition = ZLayers.DraggedDefenseRadius.rawValue;
            defenseRadiusNode.position = CGPoint(x: movePositionX, y: movePositionY);
            self.addChild(defenseRadiusNode);
            
            if(self.nodes(at: location).contains(movableDefenseNode)) {
                var defenseTouchingPath = false;
                
                for i in 0..<stonePathTiles.count {
                    if(framesTouching(frame1: movableDefenseNode.frame, frame2: stonePathTiles[i].frame)) { defenseTouchingPath = true; }
                }

                for i in 0..<placedDefenses.count {
                    if(framesTouching(frame1: movableDefenseNode.frame, frame2: placedDefenses[i].node.frame, tolerance: tileSize / 2)) { defenseTouchingPath = true; }
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
                    
                    for i in 0..<placedDefenses.count {
                        if(framesTouching(frame1: movableDefenseNode.frame, frame2: placedDefenses[i].node.frame, tolerance: tileSize / 2)) { defenseTouchingPath = true; }
                    }
                    
                    if(!defenseTouchingPath) {
                        movableDefenseNode.zPosition = ZLayers.PlacedDefense.rawValue;

                        placedDefenses.append(PlacedDefense(node: movableDefenseNode, defenseData: movableDefenseData));
                        
                        //placedDefenseNodes.append(movableDefenseNode);
                        moveableDefenseNodeExists = false;
                        
                        movableDefenseNode.color = .green;
                        movableDefenseNode.colorBlendFactor = 0.5;
                        
                        defenseRadiusNode.isHidden = true;
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [self] in
                            self.movableDefenseNode.color = .clear;
                            self.movableDefenseNode.colorBlendFactor = 0.0;
                        }
                    }
                }
            }
        }
        
        for touch in touches {
            let touchingNodes = self.nodes(at: touch.location(in: self))
            if(touchingNodes.contains(addDefenseButton)) {
                showAddDefenseMenu();
            }
            else if(touchingNodes.contains(spawnTankButton)) {
                showSpawnTankMenu();
            }
            else if(touchingNodes.contains(playButton)) {
                if(!isPlaying && GameTools.currentBattleRound + 1 < GameTools.currentBattleData.roundAmount) {
                    isPlaying = true;
                    updatePlayButton();
                    
                    GameTools.currentBattleRound = GameTools.currentBattleRound + 1;
                    updateRoundLabel();
                    
                    currentRoundTanks = GameTools.currentBattleData.rounds[GameTools.currentBattleRound].tanks;
                    
                    currentTankIndex = 0;
                    timeRoundStarted = Date().timeIntervalSince1970;
                }
            }
            else if(touchingNodes.contains(settingsButton)) {
                Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Village);
            }
        }
    }
    
    var timeRoundStarted: TimeInterval = -1; //this stores the time (since1970 milliseconds) of when the round started (used for tank spawning)
    
    var currentTankIndex: Int = 0; //the current tank index that is being or going to be spawning
    
    var currentRoundTanks: [BattleRoundTank] = []; //this array stores all the tanks for the current round. It gets set when a new round starts
    
    var tankMoveWorkItem: DispatchWorkItem?; //this work item stops the round

    
    //called when a tank has completed the SKAction move
    func tankMoveCompleted(tankIndex: Int) {
        //ensure the tank is still alive
        if(currentRoundTanks[tankIndex].health > 0 && currentRoundTanks[tankIndex].spawned) {
            currentRoundTanks[tankIndex].health = 0;
            self.removeChildren(in: [currentRoundTanks[tankIndex].node]);
            GameTools.currentBattleLives -= 1;
            updateBattleHall();
            
            if(GameTools.currentBattleLives <= 0) {
                Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Village);
                return; //return to avoid winning although the last tank caused a loss
            }
        }
    }
    
    //called when a round is over
    func roundEnded() {
        isPlaying = false;
        updatePlayButton();
        //check if the final round ended
        if(GameTools.currentBattleRound == GameTools.currentBattleData.rounds.count - 1) {
            //check if the battle was won
            if(GameTools.currentBattleLives > 0) {
                GameTools.capturedLands[GameTools.currentBattleLandPosition.x][GameTools.currentBattleLandPosition.y].captured = true;
                let land = GameTools.capturedLands[GameTools.currentBattleLandPosition.x][GameTools.currentBattleLandPosition.y];
                
                for i in 0..<land.materials.count {
                    switch(land.materials[i].type) {
                        case MaterialType.Mud:
                            GameTools.mudAmount += land.materials[i].amount;
                            break;
                        case MaterialType.Clay:
                            GameTools.clayAmount += land.materials[i].amount;
                            break;
                        case MaterialType.Wood:
                            GameTools.woodAmount += land.materials[i].amount;
                            break;
                        case MaterialType.FrozenWood:
                            GameTools.frozenWoodAmount += land.materials[i].amount;
                            break;
                        case MaterialType.Diamond:
                            GameTools.diamondAmount += land.materials[i].amount;
                            break;
                        default:
                            break;
                    }
                }
                Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Village);
            }
        }
    }
    
    var lastUpdateTime: TimeInterval = -1; //the time of when the last update frame happened
    
    override func update(_ currentTime: TimeInterval) {
        if(lastUpdateTime == -1) { lastUpdateTime = currentTime; }
        
        //let secondsBetweenFrames = currentTime - lastUpdateTime; //time (in seconds) that passed between this and last update frame
        
        if(GameTools.currentBattleRound != -1) {

            //handle the attacking of each placed defense
            for i in 0..<placedDefenses.count {
                let tankResultIndex = findNearestTankToDefense(defense: placedDefenses[i], checkDefenseRadius: true);

                if(tankResultIndex != -1) {
                    //check if a defense could perform another attack based on its last attack time and attack speed
                    if(Date().timeIntervalSince1970 >= placedDefenses[i].defenseData.lastAttackTime + Double(placedDefenses[i].defenseData.attackSpeed)) {
                        
                        
                        if(placedDefenses[i].defenseData.name == "Catapult") {
                            placedDefenses[i].node.texture = SKTexture(imageNamed: "Defenses/CatapultFire");
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
                                placedDefenses[i].node.texture = SKTexture(imageNamed: "Defenses/Catapult");
                            }
                            
                            playSoundEffect(SoundEffectType.CatapultFire);
                        }
                        else if(placedDefenses[i].defenseData.name == "Cannon") {
                            placedDefenses[i].node.texture = SKTexture(imageNamed: "Defenses/CannonFire");
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
                                placedDefenses[i].node.texture = SKTexture(imageNamed: "Defenses/Cannon");
                            }
                            
                            playSoundEffect(SoundEffectType.CannonFire);
                        }
                        
                        setMetalAmount(metalAmount + TankData.getTank(currentRoundTanks[tankResultIndex].tank).metal);
                        
                        currentRoundTanks[tankResultIndex].health -= placedDefenses[i].defenseData.attackDamage;
                        placedDefenses[i].defenseData.lastAttackTime = Date().timeIntervalSince1970;
                        
                        if(currentRoundTanks[tankResultIndex].health <= 0) {
                            currentRoundTanks[tankResultIndex].health = 0;
                            self.removeChildren(in: [currentRoundTanks[tankResultIndex].node]);
                        }
                    }
                }
            }
            
            var tankAlive = false; //indicates whether an alive tank was found
            for i in 0..<currentRoundTanks.count {
                if(currentRoundTanks[i].health > 0) { tankAlive = true; } //a non-alive tank was found switch the variable indicator
            }
            
            //if all the tanks have no health stop the round early
            if(!tankAlive) {
                tankMoveWorkItem?.cancel(); //cancel the current scheduled round stop work item
                roundEnded();
            }
        }
        
        //this code block handles all the tank spawning. It creates all the nodes and moves them
        if(isPlaying && GameTools.currentBattleRound != -1 && GameTools.currentBattleRound < GameTools.currentBattleData.rounds.count) {
            //check if the there are anymore tank indices to spawn
            if(currentTankIndex + 1 <= currentRoundTanks.count) {
                if(Date().timeIntervalSince1970 >= timeRoundStarted + Double(currentRoundTanks[currentTankIndex].time)) {
                    
                    let tankData = TankData.getTank(currentRoundTanks[currentTankIndex].tank);
                    
                    GameTools.currentBattleData.rounds[GameTools.currentBattleRound].tanks[currentTankIndex].spawned = true;
                    currentRoundTanks[currentTankIndex].spawned = true;
                    
                    GameTools.currentBattleData.rounds[GameTools.currentBattleRound].tanks[currentTankIndex].health = tankData.baseHealth;
                    currentRoundTanks[currentTankIndex].health = tankData.baseHealth;
                    
                    let tank = SKSpriteNode(texture: tankData.texture);
                    tank.position = CGPoint(x: -(self.size.width / 2), y: 10);
                    tank.size = CGSize(width: (Int(tileSize) * tankData.sizeTiles) + 16, height: (Int(tileSize) * tankData.sizeTiles) + 16);
                    tank.zPosition = ZLayers.Tank.rawValue;
                    self.addChild(tank);
                    
                    GameTools.currentBattleData.rounds[GameTools.currentBattleRound].tanks[currentTankIndex].node = tank;
                    currentRoundTanks[currentTankIndex].node = tank;

                    
                    let thisTankIndex = currentTankIndex; //create a constant to ensure the tank index won't change
                    
                    let tankMove = SKAction.moveBy(x: self.size.width, y: 0, duration: 5);
                    tank.run(tankMove, completion: {
                        self.tankMoveCompleted(tankIndex: thisTankIndex);
                    });
                    
                    //check if there are more tanks to come
                    if(currentTankIndex + 1 >= currentRoundTanks.count) {
                        //wait for tanks to fully leave before you could start the next round
                        tankMoveWorkItem = DispatchWorkItem { [self] in
                            roundEnded();
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: tankMoveWorkItem!);
                    }
                    
                    currentTankIndex += 1;
                    
                    updateRoundTanksLabel(); //update the tanks left label
                }
            }
        }
    
        lastUpdateTime = currentTime; //update the last time for next update frame
    }
    
    //sets hidden value for the add defense menu
    func setAddDefenseMenuHidden(_ value: Bool) {
        addDefenseParent.isHidden = value;
        addDefenseButton.texture = SKTexture(imageNamed: addDefenseParent.isHidden ? "Buttons/AddButton" : "Buttons/CloseButton");
        updateDefenseMenu();
    }
    
    //sets hidden value for the add defense menu
    func setSpawnTankMenuHidden(_ value: Bool) {
        spawnTankParent.isHidden = value;
        spawnTankButton.texture = SKTexture(imageNamed: spawnTankParent.isHidden ? "TankButton" : "CloseButton");
    }
    
    func showAddDefenseMenu() {
        setAddDefenseMenuHidden(!addDefenseParent.isHidden);
    }
    
    func showSpawnTankMenu() {
        setSpawnTankMenuHidden(!spawnTankParent.isHidden);
    }
}
