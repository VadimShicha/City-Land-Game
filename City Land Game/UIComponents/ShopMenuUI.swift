//
//  ShopMenuUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/16/24.
//

import SpriteKit;

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
        closeLabel.fontSize = 25;
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
