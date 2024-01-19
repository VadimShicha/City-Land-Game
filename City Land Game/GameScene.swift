//
//  GameScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var cameraNode = SKCameraNode()
    
    var lastTouch: CGPoint? //the point of where the last touch happened. nil if there isn't any touches
    var currentTouchCount: Int = 0 //the current total number of touches on the screen
    
    override func didMove(to view: SKView) {
        //create the player node
        player = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100));
        player.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2);
        self.addChild(player);
        self.camera = cameraNode;
        self.addChild(cameraNode);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentTouchCount += 1
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(currentTouchCount == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            if(lastTouch == nil) {
                lastTouch = location;
                return;
            }

            let cameraMoveAction = SKAction.move(by: CGVector(dx: -(location.x - lastTouch!.x), dy: -(location.y - lastTouch!.y)), duration: 0.1);
            cameraNode.run(cameraMoveAction);
            
            lastTouch = location;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
        currentTouchCount -= 1;
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
