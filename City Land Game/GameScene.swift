//
//  GameScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import SpriteKit
import GameplayKit

func clamp(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    if(value > max) { return max; }
    if(value < min) { return min; }
    return value;
}

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var cameraNode = SKCameraNode()
    
    var lastTouch: CGPoint? //the point of where the last touch happened. nil if there isn't any touches
    
    let minCameraScale: CGFloat = 0.3;
    let maxCameraScale: CGFloat = 5;
    
    
    override func didMove(to view: SKView) {
        //create the player node
//        player = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100));
//        player.position = CGPoint.zero;
        var lightTile = true;
        
        for x in 0...30 {
            for y in 0...30 {
                var tileColor = lightTile ? SKColor.green : SKColor.gray;
                
                if(x == 0 || x == 30 || y == 0 || y == 30) {
                    tileColor = SKColor.brown;
                }
                
                let landNode = SKSpriteNode(color: tileColor, size: CGSize(width: 100, height: 100));
                landNode.position = CGPoint(x: x * 100, y: y * 100);
                self.addChild(landNode);
                lightTile = !lightTile;
            }
        }
        //self.addChild(player);
        cameraNode.position = CGPoint.zero;
        self.camera = cameraNode;
        self.addChild(cameraNode);
        
        let pinchGesture = UIPinchGestureRecognizer();
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)));
        view.addGestureRecognizer(pinchGesture);
    }
    
    var lastCameraScale: CGFloat = 0
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if(sender.state == .began) {
            lastCameraScale = cameraNode.xScale;
        }
        
        let cameraScale = clamp(value: lastCameraScale / sender.scale, min: minCameraScale, max: maxCameraScale);
        cameraNode.setScale(cameraScale);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let totalTouchCount = event?.allTouches?.count ?? 0;
        
        if(totalTouchCount == 1) {
            let location = touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self);
            
            if(lastTouch == nil) {
                lastTouch = location;
                return;
            }

            let cameraMoveAction = SKAction.move(by: CGVector(dx: -(location.x - lastTouch!.x), dy: -(location.y - lastTouch!.y)), duration: 0.1);
            cameraMoveAction.timingMode = .linear;
            cameraNode.run(cameraMoveAction);
            
            lastTouch = location;
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouch = nil;
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
