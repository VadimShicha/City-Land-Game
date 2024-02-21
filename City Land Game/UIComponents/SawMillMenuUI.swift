//
//  SawMillMenuUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/20/24.
//

import Foundation;
import SpriteKit;

class SawMillMenuUI {
    var backgroundNode = SKShapeNode();
    var closeLabel = SKLabelNode();
    var closeLabelBackground = SKShapeNode();
    var titleLabel = SKLabelNode();
    
    var plusNode = SKSpriteNode(color: .red, size: CGSize.zero);
    var arrowNode = SKSpriteNode(color: .red, size: CGSize.zero);

    var woodMaterialItem = MaterialItemUI();
    var frozenWoodMaterialItem = MaterialItemUI();
    
    var diamondMaterialItem = MaterialItemUI();
    
    var planksMaterialItem = MaterialItemUI();
    
    var convertLabel = SKLabelNode();
    var convertLabelBackground = SKShapeNode();
    
    var regularWoodSelected = true;
    var canPurify = false;
    
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
        closeLabelBackground = SKShapeNode(rect: CGRect(
            x: -closeLabel.frame.width,
            y: -3,
            width: closeLabel.frame.width,
            height: closeLabel.frame.height
        ), cornerRadius: 5);
        closeLabelBackground.lineWidth = 10;
        closeLabelBackground.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
        closeLabelBackground.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
        closeLabel.addChild(closeLabelBackground);
        
        titleLabel.position = CGPoint(x: 0, y: scene.size.height / 3);
        titleLabel.zPosition = 100;
        titleLabel.text = "Saw Mill";
        titleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        titleLabel.fontName = "ChalkboardSE-Bold";
        titleLabel.fontSize = 30;
        titleLabel.isHidden = true;
        scene.camera?.addChild(titleLabel);
        
        let materialSize = scene.size.width / 12;
        
        woodMaterialItem.setupNode(
            size: CGSize(width: materialSize * 2, height: materialSize),
            type: MaterialType.Wood,
            amount: 100,
            fontPixelSize: materialSize / 1.5
        );
        woodMaterialItem.createBackgroundNode(color: GameTools.uiColor, cornerRadius: 8);
        woodMaterialItem.position = CGPoint(x: -(self.scene.size.width / 3) + materialSize / 2, y: (materialSize / 2) + 10);
        woodMaterialItem.label.fontSize = woodMaterialItem.label.fontSize / 1.5;
        woodMaterialItem.zPosition = 100;
        woodMaterialItem.isHidden = true;
        scene.camera?.addChild(woodMaterialItem);
        
        frozenWoodMaterialItem.setupNode(
            size: CGSize(width: materialSize * 2, height: materialSize),
            type: MaterialType.FrozenWood,
            amount: 50,
            fontPixelSize: materialSize / 1.5
        );
        frozenWoodMaterialItem.createBackgroundNode(color: GameTools.uiColor, cornerRadius: 8);
        frozenWoodMaterialItem.position = CGPoint(x: -(self.scene.size.width / 3) + materialSize / 2, y: -(materialSize / 2) - 10);
        frozenWoodMaterialItem.label.fontSize = frozenWoodMaterialItem.label.fontSize / 1.5;
        frozenWoodMaterialItem.zPosition = 100;
        frozenWoodMaterialItem.isHidden = true;
        scene.camera?.addChild(frozenWoodMaterialItem);
        
        
        diamondMaterialItem.setupNode(size: CGSize(width: materialSize * 1.5, height: materialSize), type: MaterialType.Diamond, amount: 1, fontPixelSize: materialSize / 1.5);
        diamondMaterialItem.createBackgroundNode(color: GameTools.uiColor, cornerRadius: 8);
        diamondMaterialItem.position = CGPoint.zero;
        //diamondMaterialItem.label.text = "";
        diamondMaterialItem.zPosition = 100;
        diamondMaterialItem.isHidden = true;
        scene.camera?.addChild(diamondMaterialItem);
        
        planksMaterialItem.setupNode(
            size: CGSize(width: materialSize * 2, height: materialSize),
            type: MaterialType.Planks,
            amount: 100,
            fontPixelSize: materialSize / 1.5
        );
        planksMaterialItem.createBackgroundNode(color: GameTools.uiColor, cornerRadius: 8);
        planksMaterialItem.position = CGPoint(x: (self.scene.size.width / 3) - materialSize / 2, y: 0);
        planksMaterialItem.label.fontSize = planksMaterialItem.label.fontSize / 1.5;
        planksMaterialItem.zPosition = 100;
        planksMaterialItem.isHidden = true;
        scene.camera?.addChild(planksMaterialItem);
        
        plusNode = SKSpriteNode(imageNamed: "Plus");
        plusNode.size = CGSize(width: materialSize, height: materialSize);
        plusNode.position = CGPoint(x: -(self.scene.size.width / 6) + (materialSize / 3), y: 0);
        plusNode.zPosition = 100;
        plusNode.isHidden = true;
        scene.camera?.addChild(plusNode);
        
        arrowNode = SKSpriteNode(imageNamed: "RightArrow");
        arrowNode.size = CGSize(width: materialSize, height: materialSize);
        arrowNode.position = CGPoint(x: (self.scene.size.width / 6) - (materialSize / 3), y: 0);
        arrowNode.zPosition = 100;
        arrowNode.isHidden = true;
        scene.camera?.addChild(arrowNode);
        
        convertLabel.text = "Purify";
        convertLabel.position = CGPoint(x: 0, y: -scene.size.height / 3);
        convertLabel.zPosition = 100;
        convertLabel.fontColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
        convertLabel.fontName = "ChalkboardSE-Bold";
        convertLabel.fontSize = Tools.pixelsToPoints(materialSize / 2);
        convertLabel.isHidden = true;
        scene.camera?.addChild(convertLabel);
        convertLabelBackground = SKShapeNode(rect: CGRect(
            x: -convertLabel.frame.width / 2,
            y: -3,
            width: convertLabel.frame.width,
            height: convertLabel.frame.height
        ), cornerRadius: 5);
        convertLabelBackground.lineWidth = 15;
        convertLabelBackground.fillColor = GameTools.uiColor;
        convertLabelBackground.strokeColor = GameTools.uiColor;
        convertLabel.addChild(convertLabelBackground);
        
        setWoodTypeSelected(regular: true);
        updateResources();
    }
    
    func setMenuHidden(_ value: Bool) {
        //if the menu is being opened update the resource colors
        if(!value) {
            updateResources();
        }
        
        backgroundNode.isHidden = value;
        closeLabel.isHidden = value;
        titleLabel.isHidden = value;
        
        woodMaterialItem.isHidden = value;
        frozenWoodMaterialItem.isHidden = value;
        diamondMaterialItem.isHidden = value;
        planksMaterialItem.isHidden = value;
        
        plusNode.isHidden = value;
        arrowNode.isHidden = value;
        
        convertLabel.isHidden = value;
    }
    
    func setWoodTypeSelected(regular: Bool) {
        regularWoodSelected = regular;
        woodMaterialItem.backgroundNode.fillColor = (regular ? GameTools.darkUiColor : GameTools.uiColor);
        frozenWoodMaterialItem.backgroundNode.fillColor = (regular ? GameTools.uiColor : GameTools.darkUiColor);
        updateResources();
    }
    
    func updateResources() {
        let textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
        canPurify = true;

        woodMaterialItem.label.fontColor = (GameTools.woodAmount < 100 ? GameTools.redUiColor : textColor);
        frozenWoodMaterialItem.label.fontColor = (GameTools.frozenWoodAmount < 50 ? GameTools.redUiColor : textColor);
        diamondMaterialItem.label.fontColor = (GameTools.diamondAmount < 1 ? GameTools.redUiColor : textColor);
        
        if(regularWoodSelected && GameTools.woodAmount < 100) { canPurify = false; }
        if(!regularWoodSelected && GameTools.frozenWoodAmount < 50) { canPurify = false; }
        if(GameTools.diamondAmount < 1) { canPurify = false; }
        
        if(!canPurify) { convertLabel.fontColor = GameTools.redUiColor; }
        else { convertLabel.fontColor = textColor; }
    }
}

