//
//  AttackMenuUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/16/24.
//

import SpriteKit;

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
        closeLabel.fontSize = 25;
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
