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
    var backgroundNode = SKShapeNode(rect: CGRect.zero, cornerRadius: 0)
    
    var itemSize = CGSize.zero;
    
    func setupNode(size: CGSize, type: MaterialType, amount: Int, fontPixelSize: CGFloat = -1, hasDebugFrame: Bool = false) {
        imageNode = SKSpriteNode(imageNamed: GameTools.getMaterialAssetName(type));
        imageNode.size = CGSize(width: size.height, height: size.height);
        imageNode.position = CGPoint(x: -(size.width / 2) + (size.height / 2), y: 0);
        addChild(imageNode);
        
        label = SKLabelNode(text: Tools.createDigitSeparatedString(amount, seperator: ","));
        label.fontColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1);
        label.fontName = "ChalkboardSE-Bold";
        if(fontPixelSize == -1) { label.fontSize = Tools.pixelsToPoints(size.height); }
        else { label.fontSize = Tools.pixelsToPoints(fontPixelSize); }
        label.horizontalAlignmentMode = .left;
        let labelPositionY = (fontPixelSize == -1 ? -label.frame.height / 2 : -fontPixelSize / 4);
        label.position = CGPoint(x: imageNode.position.x + (size.height / 2) + 5, y: labelPositionY);
        addChild(label);
        
        itemSize = size;
        
        //adds a test background node behind to show the frame of this node
        if(hasDebugFrame) {
            let backgroundTestNode = SKSpriteNode(color: .red, size: CGSize(width: size.width, height: size.height));
            backgroundTestNode.position = CGPoint(x: 0, y: 0);
            addChild(backgroundTestNode);
            print("WARNING: Debug background node is being used in MaterialItemUI");
        }
    }
    
    //creates a background node for the material item
    func createBackgroundNode(color: UIColor, cornerRadius: CGFloat) {
        backgroundNode = SKShapeNode(rect: CGRect(x: -itemSize.width / 2, y: -itemSize.height / 2, width: itemSize.width, height: itemSize.height), cornerRadius: cornerRadius);
        backgroundNode.zPosition = self.zPosition - 1;
        backgroundNode.fillColor = color;
        backgroundNode.strokeColor = .clear;
        addChild(backgroundNode);
    }
}
