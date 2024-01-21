//
//  GameScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import SpriteKit;
import GameplayKit;

class GameScene: SKScene {
    
    var cameraNode = SKCameraNode();
    
    var lastTouch: CGPoint?; //the point of where the last touch happened. nil if there isn't any touches
    
    let minCameraScale: CGFloat = 0.5; //the minimum you can zoom the camera out
    let maxCameraScale: CGFloat = 15; //the maximum you can zoom the camera out/
    
    override func didMove(to view: SKView) {
        let generatedLandNodes = LandGenerator.generateLandMap(); //generate the land map
        for i in 0..<generatedLandNodes.count {
            self.addChild(generatedLandNodes[i]); //add the land node to the view
        }
        
        for x in 0...3 {
            for y in -2...1 {
                GameTools.capturedLands[GameTools.mapSpawnX + x][GameTools.mapSpawnY + y].captured = true;
            }
        }
//        borderNodes = LandGenerator.generateCapturedBorders();
//        for i in 0..<borderNodes.count {
//            self.addChild(borderNodes[i]);
//        }
        
        GameTools.borderNodesParent = SKSpriteNode(color: SKColor.red, size: CGSize(width: 0, height: 0));
        let borderNodes = LandGenerator.generateCapturedBorders();
        for i in 0..<borderNodes.count {
            GameTools.borderNodesParent.addChild(borderNodes[i]);
        }
        
        self.addChild(GameTools.borderNodesParent);
        
        let cityHall = SKSpriteNode(imageNamed: "CityHall");
        cityHall.position = CGPoint(x: (GameTools.mapSpawnX * GameTools.landTileSize) + (GameTools.landTileSize / 2), y: (GameTools.mapSpawnY * GameTools.landTileSize) + (GameTools.landTileSize / 2));
        cityHall.size = CGSize(width: 512, height: 512);
        cityHall.zPosition = 1;
        self.addChild(cityHall);
        
        cameraNode.position = CGPoint(x: GameTools.mapWidth * (GameTools.landTileSize / 2), y: GameTools.mapHeight * (GameTools.landTileSize / 2));
        cameraNode.setScale(maxCameraScale / 4);
        self.camera = cameraNode;
        self.addChild(cameraNode);
        
        //setup the pinch gesture that is used for zooming
        let pinchGesture = UIPinchGestureRecognizer();
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)));
        view.addGestureRecognizer(pinchGesture);
    }
    
    var lastCameraScale: CGFloat = 0; //the camera scale when the pinch gesture began
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if(sender.state == .began) {
            lastCameraScale = cameraNode.xScale;
        }
        
        let cameraScale = Tools.clamp(value: lastCameraScale / sender.scale, min: minCameraScale, max: maxCameraScale);
        cameraNode.setScale(cameraScale);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchingNodes = self.nodes(at: touches[touches.index(touches.startIndex, offsetBy: 0)].location(in: self));
        
        for i in 0..<touchingNodes.count {
            if(touchingNodes[i].name != nil) {
                if(touchingNodes[i].name!.hasPrefix("LandNode:")) {
                    let positionsArray = touchingNodes[i].name!.dropFirst(9).components(separatedBy: ",");
                    if(positionsArray.count != 2) {
                        print("LandNode name doesn't contain position");
                        return;
                    }
                    let posX = Int(positionsArray[0])!;
                    let posY = Int(positionsArray[1])!;
                    GameTools.capturedLands[posX][posY].captured = true;
                    
                    GameTools.borderNodesParent.removeAllChildren();
                    let borderNodes = LandGenerator.generateCapturedBorders();
                    for i in 0..<borderNodes.count {
                        GameTools.borderNodesParent.addChild(borderNodes[i]);
                    }
                    
                    if(event?.allTouches?.count == 1) {
                        Tools.changeScenes(fromScene: self, toSceneType: Tools.SceneType.Battle);
                    }
                }
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let totalTouchCount = event?.allTouches?.count ?? 0;
        
        //if there is only 1 touch then move the camera
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
