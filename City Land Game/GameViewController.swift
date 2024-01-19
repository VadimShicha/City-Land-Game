//
//  GameViewController.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        //create a scene with the device's dimensions
        let scene = GameScene(size: CGSize(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height));
        scene.scaleMode = .aspectFill;
        
        let view = self.view as! SKView; //get the view
        view.showsFPS = true; //show the frames per second
        view.showsNodeCount = true;
        view.ignoresSiblingOrder = true; //ignore the order that the children are in for z-positioning
        view.presentScene(scene);
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown;
        } else {
            return .all;
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true;
    }
}
