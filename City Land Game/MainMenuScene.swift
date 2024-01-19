//
//  MainMenuScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/18/24.
//

import Foundation
import SpriteKit
import UIKit

class MainMenuScene: SKScene {

//    override func didMove(to view: SKView) {
//        let
//        
//    }
    var previousCameraPoint = CGPoint.zero

  override func didMove(to view: SKView) {
    let panGesture = UIPanGestureRecognizer()
    panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
    view.addGestureRecognizer(panGesture)
  }

  @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
    // The camera has a weak reference, so test it
    guard let camera = self.camera else {
      return
    }
    // If the movement just began, save the first camera position
    if sender.state == .began {
      previousCameraPoint = camera.position
    }
    // Perform the translation
    let translation = sender.translation(in: self.view)
    let newPosition = CGPoint(
      x: previousCameraPoint.x + translation.x * -1,
      y: previousCameraPoint.y + translation.y
    )
    camera.position = newPosition
  }
    
//    let settingsButton = UIButton()
//    settingsButton.frame = Tools.instance.createCenteredRect(
//        x: UIScreen.main.bounds.width / 2,
//        y: (UIScreen.main.bounds.height / 2) + 2 * ((UIScreen.main.bounds.height / 16) + 10),
//        width: UIScreen.main.bounds.width / 2,
//        height: UIScreen.main.bounds.height / 16
//    )
//    settingsButton.setTitle("Settings", for: .normal)
//    settingsButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 25)
//    settingsButton.layer.cornerRadius = 5
//    settingsButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//    settingsButton.addTarget(self, action: #selector(freeplayButtonClicked), for: .touchUpInside)
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
