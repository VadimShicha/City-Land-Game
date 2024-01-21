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
    
    let lightTileColor = UIColor(red: 92 / 255, green: 161 / 255, blue: 63 / 255, alpha: 60 / 255);
    let darkTileColor = UIColor(red: 67 / 255, green: 130 / 255, blue: 40 / 255, alpha: 60 / 255);
    
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
                //stonePathTile.size = CGSize(width: 32, height: 32);
                stonePathTile.position = CGPoint(x: CGFloat(x) * tileSize, y: CGFloat(y) * tileSize);
                self.addChild(stonePathTile);
                lightColor = !lightColor;
            }
        }
        
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
        addDefenseButton.setTitle("+", for: .normal);
        addDefenseButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 25);
        addDefenseButton.titleLabel?.baselineAdjustment = .none;
        addDefenseButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        addDefenseButton.titleLabel?.numberOfLines = 1;
        addDefenseButton.layer.cornerRadius = 5;
        addDefenseButton.backgroundColor = #colorLiteral(red: 0.7370413554, green: 0.3761309979, blue: 0.1578397769, alpha: 1);
        self.view?.addSubview(addDefenseButton);
    }
}
