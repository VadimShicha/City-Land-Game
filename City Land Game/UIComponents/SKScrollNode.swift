//
//  SKScrollNode.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/17/24.
//

import Foundation;
import SpriteKit;
import SwiftySKScrollView;

//convenient class to creating scroll views inside of SpriteKit scenes
//this class uses the 'SwiftySKScrollView' package to create the scroll view
//it has the movable scroll node built in and crops any content that is outside of the scroll view frame (clipping)
class SKScrollNode {
    
    var scrollView: SwiftySKScrollView;
    var movableScrollNode = SKNode(); //the parent of all the content nodes
    var cropNode: SKCropNode; //this node is used to hide the content that leaves the bounds of the scroll view (clipping to bounds)
    
    private var scrollDirection: SwiftySKScrollView.ScrollDirection;
    
    //initializes an SKScrollNode
    //
    //scrollViewFrame - a frame of the scroll view
    //NOTE: x and y positions are center aligned automatically
    //
    //contentSize - size of the content that will be in the scroll view
    //NOTE: the axis of the scroll direction has to be bigger than the scroll view size to have a scrollable view
    //
    //sceneCenter - center position of the scene that this scroll view is in
    //NOTE: [scene.frame.midX] and [scene.frame.midY] could be used to get the center point
    //
    //direction - the direction the scroll view scrolls
    //NOTE: the visual scroll bar is turned on by default but could be changed using [setScrollBarHidden()] function
    init(scrollViewFrame: CGRect, contentSize: CGSize, sceneCenter: CGPoint, direction: SwiftySKScrollView.ScrollDirection) {
        var centeredScrollFrame = scrollViewFrame;
        let scrollViewX = sceneCenter.x - (scrollViewFrame.width / 2) + scrollViewFrame.minX;
        let scrollViewY = sceneCenter.y - (scrollViewFrame.height / 2) - scrollViewFrame.minY;
        
        centeredScrollFrame = CGRect(x: scrollViewX, y: scrollViewY, width: scrollViewFrame.width, height: scrollViewFrame.height);
        
        scrollView = SwiftySKScrollView(frame: centeredScrollFrame, moveableNode: movableScrollNode, direction: direction);
        scrollView.contentSize = CGSize(width: contentSize.width, height: contentSize.height);
        movableScrollNode.position = CGPoint(x: 0, y: 0);
        
        cropNode = SKCropNode();
        let cropMaskNode = SKSpriteNode(color: .yellow, size: CGSize(width: scrollViewFrame.width, height: scrollViewFrame.height));
        cropNode.maskNode = cropMaskNode;
        cropNode.position = CGPoint(x: scrollViewFrame.minX, y: scrollViewFrame.minY);
        cropNode.zPosition = 500;
        cropNode.addChild(movableScrollNode);
        
        scrollDirection = direction; //stores the direction of scrolling
        setScrollBarHidden(false); //default to showing the scroll bars
    }
    
    func scrollTo(_ position: CGPoint, animated: Bool) {
        scrollView.scrollRectToVisible(CGRect(x: position.x, y: position.y, width: scrollView.frame.width, height: scrollView.frame.height), animated: animated);
    }
    
    //adds a child to the scroll view
    func addChild(_ node: SKNode) {
        movableScrollNode.addChild(node);
    }
    
    //removes a child from the scroll view
    func removeChildren(_ nodes: [SKNode]) {
        movableScrollNode.removeChildren(in: nodes);
    }
    
    //removes all children from the scroll view
    func removeAllChildren() {
        movableScrollNode.removeChildren(in: movableScrollNode.children);
    }
    
    //returns the view that needs to be added to the subviews
    func getAddToSubview() -> SwiftySKScrollView {
        return scrollView;
    }
    
    //returns the node that needs to be added to the scene
    func getAddToSceneNode() -> SKCropNode {
        return cropNode;
    }
    
    //sets the hidden value for the scroll bars
    func setScrollBarHidden(_ value: Bool) {
        if(scrollDirection == .horizontal) { scrollView.showsHorizontalScrollIndicator = !value; }
        else if(scrollDirection == .vertical) { scrollView.showsVerticalScrollIndicator = !value; }
    }
    
    //sets the hidden value for the scroll view
    func setHidden(_ value: Bool) {
        scrollView.isDisabled = value;
        scrollView.isHidden = value;
        movableScrollNode.isHidden = value;
    }
}

//EXAMPLE of this class being used to create a vertical scroll view with 1 node
//the scroll view is 75% of the screen size
//the content height size is 5 times the scroll view height
//
//CODE:
/*
 scrollNode = SKScrollNode(
     scrollViewFrame: CGRect(x: 0, y: 0, width: scene.size.width / 1.5, height: scene.size.height / 1.5),
     contentSize: CGSize(width: scene.size.width / 1.5, height: scene.size.height * 5), //make the content 5 times the height of the scroll view frame height
     sceneCenter: CGPoint(x: scene.frame.midX, y: scene.frame.midY), //provide the center position of the scene
     direction: .vertical //create a vertical scroll view
 );
 scrollNode.scrollView.backgroundColor = #colorLiteral(red: 0.3950564931, green: 0.4677601484, blue: 1, alpha: 0.5); //the background color of the scroll view
 
 //create a node to add to the scroll view
 let scrollNode1 = SKSpriteNode(color: .red, size: CGSize(width: 300, height: 100));
 scrollNode1.position = CGPoint.zero;
 scrollNode.addChild(scrollNode1);
 
 scene.camera?.addChild(scrollNode.getAddToSceneNode()); //add the content to the camera to have it always show (even when the camera moves)
 scene.view?.addSubview(scrollNode.getAddToSubview());
*/
