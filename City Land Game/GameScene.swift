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
    let maxCameraScale: CGFloat = 8;
    
    let mapWidth: Int = 30;
    let mapHeight: Int = 30;
    
    override func didMove(to view: SKView) {
        //create the player node
        let noiseMap = createNoiseMap(width: CGFloat(mapWidth), height: CGFloat(mapHeight), persistance: 0.65);
        
        for x in 0..<mapWidth {
            for y in 0..<mapHeight {
                let noisePosition = vector2(Int32(x), Int32(y));
                let noiseValue = noiseMap.value(at: noisePosition);
                
                var tileColor = SKColor.brown;
                
                print(noiseValue);
                if(noiseValue > 0.85) {
                    tileColor = SKColor.blue;
                }
                else if(noiseValue > 0.75) {
                    tileColor = SKColor.yellow;
                }
                else if(noiseValue > 0.05) {
                    tileColor = SKColor.green;
                }
                else if(noiseValue > -0.3) {
                    tileColor = SKColor.gray;
                }
                else if(noiseValue > -0.7) {
                    tileColor = SKColor.white;
                }
                else {
                    tileColor = SKColor.cyan;
                }
                
                
                
                if(x == 0 || x == mapWidth - 1 || y == 0 || y == mapHeight - 1) {
                    tileColor = SKColor.brown;
                }
                
                let landNode = SKSpriteNode(color: tileColor, size: CGSize(width: 100, height: 100));
                landNode.position = CGPoint(x: x * 100, y: y * 100);
                self.addChild(landNode);
            }
        }
        cameraNode.position = CGPoint.zero;
        self.camera = cameraNode;
        self.addChild(cameraNode);
        
        let pinchGesture = UIPinchGestureRecognizer();
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)));
        view.addGestureRecognizer(pinchGesture);
    }
    
    func createNoiseMap(width: CGFloat, height: CGFloat, persistance: CGFloat = 0.9) -> GKNoiseMap {
        let source = GKPerlinNoiseSource();
        source.persistence = persistance; //how likely the noise values are to change. The higher the more often
        
        let noise = GKNoise(source);
        let size = vector2(1.0, 1.0);
        let origin = vector2(0.0, 0.0);
        let sampleCount = vector2(Int32(width), Int32(height))
        
        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true);
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
