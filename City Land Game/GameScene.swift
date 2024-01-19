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

    override func didMove(to view: SKView) {
        //create the player node
        player = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100));
        player.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2);
        //player.isUserInteractionEnabled = false;
        self.addChild(player);
        
        self.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanCamera)));
    }
    
    @objc func handlePanCamera(gesture: UIPanGestureRecognizer) {
        
        if(gesture.state == .changed) {
            var translation = gesture.translation(in: self.view);
            if(translation.x > 100) {
                translation.x = 100;
            }
            if(translation.x < -100) {
                translation.x = -100;
            }
            if(translation.y > 100) {
                translation.y = 100;
            }
            if(translation.y < -100) {
                translation.y = -100;
            }
            
            player.position.x += translation.x * 0.01;
            player.position.y -= translation.y * 0.01;
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
