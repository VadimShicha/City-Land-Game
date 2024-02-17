//
//  SettingsMenuUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/16/24.
//

import SpriteKit;

class SettingsMenuUI {
    var backgroundNode = SKShapeNode();
    var closeLabel = SKLabelNode();
    var titleLabel = SKLabelNode();
    
    var saveDataButtonNode = SKSpriteNode();
    var loadDataButtonNode = SKSpriteNode();

    var scene: SKScene;
    
    init(_ scene: SKScene) {
        self.scene = scene;
    }
    
    func setupMenu() {
        let backgroundWidth = scene.size.width / 1.25;
        let backgroundHeight = scene.size.height / 1.25;
        backgroundNode = SKShapeNode(rect: CGRect(
            x: -scene.size.width / 1.25 / 2,
            y: -scene.size.height / 1.25 / 2,
            width: backgroundWidth,
            height: backgroundHeight
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
        closeLabel.fontSize = 25;
        closeLabel.horizontalAlignmentMode = .right;
        closeLabel.isHidden = true;
        scene.camera?.addChild(closeLabel);
        
        titleLabel.position = CGPoint(x: 0, y: scene.size.height / 3);
        titleLabel.zPosition = 100;
        titleLabel.text = "City Settings";
        titleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        titleLabel.fontName = "ChalkboardSE-Bold";
        titleLabel.fontSize = 30;
        titleLabel.isHidden = true;
        scene.camera?.addChild(titleLabel);
        
        let saveButtonSize = scene.size.width / 16;
        saveDataButtonNode = SKSpriteNode(imageNamed: "Buttons/SaveDataButton");
        let saveButtonPositionX = -(backgroundWidth / 2) + (saveButtonSize / 2);
        let saveButtonPositionY = -(backgroundHeight / 2) + (saveButtonSize / 2);
        saveDataButtonNode.position = CGPoint(x: saveButtonPositionX + 5, y: saveButtonPositionY + 5);
        saveDataButtonNode.size = CGSize(width: saveButtonSize, height: saveButtonSize);
        saveDataButtonNode.zPosition = 100;
        saveDataButtonNode.isHidden = true;
        scene.camera?.addChild(saveDataButtonNode);
        
//        loadDataButtonNode = SKSpriteNode(imageNamed: "Buttons/LoadDataButton");
//        loadDataButtonNode.position = CGPoint(x: scene.size.width / 16, y: 0);
//        loadDataButtonNode.size = CGSize(width: scene.size.width / 12, height: scene.size.width / 12);
//        loadDataButtonNode.zPosition = 100;
//        loadDataButtonNode.isHidden = true;
//        scene.camera?.addChild(loadDataButtonNode);
    }
    
    func showMenu() {
        backgroundNode.isHidden = false;
        closeLabel.isHidden = false;
        titleLabel.isHidden = false;
        saveDataButtonNode.isHidden = false;
        //loadDataButtonNode.isHidden = false;
    }
    
    func hideMenu() {
        backgroundNode.isHidden = true;
        closeLabel.isHidden = true;
        titleLabel.isHidden = true;
        saveDataButtonNode.isHidden = true;
        //loadDataButtonNode.isHidden = true;
    }
}
