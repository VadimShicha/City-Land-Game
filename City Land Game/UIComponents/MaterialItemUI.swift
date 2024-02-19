//
//  MaterialItemUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/18/24.
//

import Foundation;
import SpriteKit;

class MaterialItemUI: SKNode {
    
    var imageNode = SKSpriteNode(color: .red, size: CGSize.zero);
    var label = SKLabelNode(text: "0");
    
    func setupNode(size: CGSize, type: MaterialType, amount: Int, hasDebugFrame: Bool = false) {
        imageNode = SKSpriteNode(imageNamed: GameTools.getMaterialAssetName(type));
        imageNode.size = CGSize(width: size.height, height: size.height);
        imageNode.position = CGPoint(x: -(size.width / 2) + (size.height / 2), y: 0);
        addChild(imageNode);
        
        label = SKLabelNode(text: Tools.createDigitSeparatedString(amount, seperator: ","));
        label.fontColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
        label.fontName = "ChalkboardSE-Bold";
        label.fontSize = Tools.pixelsToPoints(size.height);
        label.horizontalAlignmentMode = .left;
        label.position = CGPoint(x: imageNode.position.x + (size.height / 2) + 5, y: -label.frame.height / 2);
        addChild(label);
        
        //adds a test background node behind to show the frame of this node
        if(hasDebugFrame) {
            let backgroundNode = SKSpriteNode(color: .red, size: CGSize(width: size.width, height: size.height));
            backgroundNode.position = CGPoint(x: 0, y: 0);
            addChild(backgroundNode);
            print("WARNING: Debug background node is being used in MaterialItemUI");
        }
    }
}
