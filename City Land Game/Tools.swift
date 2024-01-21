//
//  Tools.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/19/24.
//

import Foundation;
import SpriteKit;

//struct for holding an x and y value
struct GameVector2 {
    var x: CGFloat = 0;
    var y: CGFloat = 0;
    
    static let zero = GameVector2(x: 0, y: 0);
    static let one = GameVector2(x: 1, y: 1);
}

//struct for holding an x and y int value
struct GameVector2Int {
    var x: Int = 0;
    var y: Int = 0;
    
    static let zero = GameVector2Int(x: 0, y: 0);
    static let one = GameVector2Int(x: 1, y: 1);
}

//class used to bring useful functions throughout the app
class Tools {
    enum SceneType {
        case Village, Battle
    }
    
    //clamps a number between two numbers (a number range). (Ex: 10 clamped in a 0 and 5 range would return 5)
    static func clamp(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        if(value > max) { return max; }
        if(value < min) { return min; }
        return value;
    }
    
    static func changeScenes(fromScene: SKScene, toSceneType: SceneType) {
        let scene = getScene(sceneType: toSceneType); //get the SKScene from the to-scene
        scene.scaleMode = .aspectFill; //set the scene scale mode
        
        //remove all subviews from view (removes UI elements that are attached)
        if(fromScene.view != nil) {
            //loop through all subviews in view
            for subView in fromScene.view!.subviews {
                subView.removeFromSuperview();
            }
        }
        fromScene.view?.presentScene(scene); //present the scene using the currently-renderering scene's view
    }
    
    //get the scene with a scene type
    static func getScene(sceneType: SceneType) -> SKScene {
        switch(sceneType) {
            case SceneType.Village:
                return GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height));
            case SceneType.Battle:
                return BattleScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height));
        }
    }
}
