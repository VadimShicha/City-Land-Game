//
//  SKScrollNode.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/17/24.
//

//let cropNode = SKCropNode();
//let cropMaskNode = SKSpriteNode(color: .yellow, size: CGSize(width: scene.size.width / 1.5, height: scene.size.height / 1.5));
//cropNode.maskNode = cropMaskNode;
//cropNode.position = CGPoint.zero;
//cropNode.zPosition = 105;
//cropNode.addChild(movableScrollNode);
//scene.camera?.addChild(cropNode);
//
//let scrollViewFrame = CGRect(x: 0, y: 0, width: scene.size.width / 1.5, height: scene.size.height / 1.5);
//scrollView = SwiftySKScrollView(
//    frame: scrollViewFrame,
//    moveableNode: movableScrollNode,
//    direction: .vertical
//);
//guard let scrollView = scrollView else { return; }
//scrollView.contentSize = CGSize(width: scrollViewFrame.width, height: scrollViewFrame.height * 5);
//scrollView.center = CGPoint(x: scene.frame.midX, y: scene.frame.midY);
//scrollView.contentOffset = CGPoint(x: 0, y: 10);
//scrollView.isDisabled = true;
//scrollView.isHidden = true;
//scrollView.showsVerticalScrollIndicator = true;
//scene.view?.addSubview(scrollView);
//
//movableScrollNode.isHidden = true;
//
//let scrollNode1 = SKSpriteNode(color: .red, size: CGSize(width: 300, height: 100));
//scrollNode1.position = CGPoint.zero;
//movableScrollNode.addChild(scrollNode1);

import Foundation;
import SpriteKit;
import SwiftySKScrollView;

class SKScrollNode {
    
    var scrollView: SwiftySKScrollView;
    var movableScrollNode = SKNode();
    var cropNode: SKCropNode;
    
    init(scrollViewFrame: CGRect, contentSize: CGSize, scrollViewCenter: CGPoint, direction: SwiftySKScrollView.ScrollDirection) {
        scrollView = SwiftySKScrollView(frame: scrollViewFrame, moveableNode: movableScrollNode, direction: direction);
        scrollView.contentSize = CGSize(width: contentSize.width, height: contentSize.height);
        scrollView.center = scrollViewCenter;
        
        //default to showing the scroll bars
        if(direction == .horizontal) { scrollView.showsHorizontalScrollIndicator = true; }
        else { scrollView.showsVerticalScrollIndicator = true; }
        
        cropNode = SKCropNode();
        let cropMaskNode = SKSpriteNode(color: .yellow, size: CGSize(width: scrollViewFrame.width, height: scrollViewFrame.height));
        cropNode.maskNode = cropMaskNode;
        cropNode.position = CGPoint(x: scrollViewFrame.minX, y: scrollViewFrame.minY);
        cropNode.zPosition = 105;
        cropNode.addChild(movableScrollNode);
    }
    
    //adds a child to the scroll view
    func addChild(_ node: SKNode) {
        movableScrollNode.addChild(node);
    }
    
    //returns the view that needs to be added to the subviews
    func getAddToSubview() -> SwiftySKScrollView {
        return scrollView;
    }
    
    //returns the node that needs to be added to the scene
    func getAddToSceneNode() -> SKCropNode {
        return cropNode;
    }
    
    //sets the hidden value for the scroll view
    func setHidden(_ value: Bool) {
        scrollView.isDisabled = value;
        scrollView.isHidden = value;
        movableScrollNode.isHidden = value;
    }
}
