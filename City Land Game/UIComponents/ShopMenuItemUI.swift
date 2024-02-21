//
//  ShopMenuItemUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/18/24.
//

import Foundation;
import SpriteKit;

class ShopMenuItemUI: SKNode {
    var backgroundNode = SKSpriteNode(color: .red, size: CGSize.zero);
    var imageNode = SKSpriteNode(color: .red, size: CGSize.zero);
    var titleLabel = SKLabelNode(text: "");
    
    func setupNode(size: CGSize, imageName: String, title: String, materials: [MaterialData]) {
        backgroundNode = SKSpriteNode(color: GameTools.uiColor, size: size);
        //backgroundNode.position = position;
        addChild(backgroundNode);
        
        imageNode = SKSpriteNode(imageNamed: imageName);
        imageNode.size = CGSize(width: size.height / 1.25, height: size.height / 1.25);
        let imageNodeOffsetX = (imageNode.size.width / 2) + 5;
        imageNode.position = CGPoint(x: -(size.width / 2) + imageNodeOffsetX, y: 0);
        addChild(imageNode);
        
        titleLabel.text = title;
        titleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        titleLabel.fontName = "ChalkboardSE-Bold";
        titleLabel.fontSize = 18;
        titleLabel.position = CGPoint(x: 0, y: (size.height / 2) - titleLabel.frame.height);
        addChild(titleLabel);
        
        for i in 0..<3 {
            if(i >= materials.count) { break; }
            
            let materialSize = size.height / 4;
            let materialPositionX = (i - 1) * (Int(size.width) / 4);
            
            let materialItem = MaterialItemUI();
            materialItem.setupNode(
                size: CGSize(width: Int(size.width / 4), height: Int(materialSize)),
                type: materials[i].type,
                amount: materials[i].amount,
                hasDebugFrame: false
            );
            materialItem.position = CGPoint(x: materialPositionX + (Int(imageNode.size.width) / 2), y: 0);
            
            //set the color red if you don't have the needed amount
            if(GameTools.getMaterialAmount(type: materials[i].type) < materials[i].amount) {
                materialItem.label.fontColor = GameTools.redUiColor;
            }
            addChild(materialItem);
        }
    }
}
