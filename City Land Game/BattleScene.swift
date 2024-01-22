//
//  BattleScene.swift
//  City Land Game
//
//  Created by Vadim Shicha on 1/20/24.
//

import Foundation;
import SpriteKit;

class BattleScene: SKScene {
    var cameraNode = SKCameraNode();
    
    //let lightTileColor = UIColor(red: 92 / 255, green: 161 / 255, blue: 63 / 255, alpha: 60 / 255);
    //let darkTileColor = UIColor(red: 67 / 255, green: 130 / 255, blue: 40 / 255, alpha: 60 / 255);
    
    let lightTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 15 / 255);
    let darkTileColor = UIColor(red: 128 / 255, green: 128 / 255, blue: 128 / 255, alpha: 45 / 255);
    
    override func didMove(to view: SKView) {
        let backgroundNode = SKSpriteNode(imageNamed: "GreenLandsBackground");
        backgroundNode.size = CGSize(width: 1024, height: 512);
        backgroundNode.position = CGPoint.zero;
        backgroundNode.zPosition = -10;
        self.addChild(backgroundNode);
        
        for i in -15...15 {
            let stonePathTile = SKSpriteNode(imageNamed: "StonePathTile");
            stonePathTile.size = CGSize(width: 45, height: 45);
            stonePathTile.position = CGPoint(x: i * 45, y: 0);
            self.addChild(stonePathTile);
        }
        
        var lightColor = true;
        let tileSize = self.size.width / 30;
        
        for y in -7...7 {
            if(y == -1 || y == 0 || y == 1) { continue; }
            
            for x in -14...14 {
                
                let stonePathTile = SKSpriteNode(color: lightColor ? lightTileColor : darkTileColor, size: CGSize(width: tileSize, height: tileSize));
                stonePathTile.position = CGPoint(x: CGFloat(x) * tileSize, y: CGFloat(y) * tileSize);
                stonePathTile.zRotation = 45 * .pi / 180;
                self.addChild(stonePathTile);
                lightColor = !lightColor;
            }
        }
        
        let spearTower = SKSpriteNode(imageNamed: "SpearTower");
        spearTower.size = CGSize(width: tileSize * 3, height: tileSize * 3);
        spearTower.position = CGPoint(x: 0, y: -5 * tileSize);
        self.addChild(spearTower);
        
        cameraNode.position = CGPoint.zero;
        self.camera = cameraNode;
        self.addChild(cameraNode);
        
        let addDefenseButton = UIButton();
        addDefenseButton.frame = CGRect(
            x: 5,
            y: self.size.height - 50 - 5,
            width: 50,
            height: 50
        );
        addDefenseButton.setBackgroundImage(UIImage(named: "AddButton"), for: .normal);
        self.view?.addSubview(addDefenseButton);
    }
}
