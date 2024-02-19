//
//  ShopMenuUI.swift
//  City Land Game
//
//  Created by Vadim Shicha on 2/16/24.
//

import SpriteKit;
import SwiftySKScrollView;

class ShopMenuUI {
    var backgroundNode = SKShapeNode();
    var closeLabel = SKLabelNode();
    var closeLabelBackground = SKShapeNode();
    var titleLabel = SKLabelNode();
    
    var bodyTabLabels: [SKLabelNode] = [];
    var bodyTabContent: [SKNode] = [];
    
    let shopTabs: [String] = ["Production", "Defenses", "Decorations"];
    let selectedTabTextColor = #colorLiteral(red: 0.3459514054, green: 0.3769503683, blue: 0.4166447747, alpha: 1);
    let unselectedTabTextColor = #colorLiteral(red: 0.4612971827, green: 0.4612971827, blue: 0.4612971827, alpha: 1);
    
    var currentTabIndex = 0;
    
    var scrollNode: SKScrollNode;

    var scene: SKScene;
    
    
    init(_ scene: SKScene) {
        self.scene = scene;
        
        scrollNode = SKScrollNode(
            scrollViewFrame: CGRect(x: 0, y: -scene.size.height / 8, width: scene.size.width / 1.5, height: scene.size.height / 2),
            contentSize: CGSize(width: scene.size.width / 1.5, height: scene.size.height * 5),
            sceneCenter: CGPoint(x: scene.frame.midX, y: scene.frame.midY),
            direction: .vertical
        );
        //scrollNode.scrollView.backgroundColor = #colorLiteral(red: 0.3950564931, green: 0.4677601484, blue: 1, alpha: 0.5);
        scrollNode.scrollView.backgroundColor = #colorLiteral(red: 0.5717771864, green: 0.393343057, blue: 0.1795284801, alpha: 0.35);
        
        let scrollNode1 = SKSpriteNode(color: .red, size: CGSize(width: 300, height: 100));
        scrollNode1.position = CGPoint.zero;
        scrollNode.addChild(scrollNode1);
        
        scene.camera?.addChild(scrollNode.getAddToSceneNode());
        scene.view?.addSubview(scrollNode.getAddToSubview());
        scrollNode.setHidden(true);
    }
    
    func setupMenu() {
        
        backgroundNode = SKShapeNode(rect: CGRect(
            x: -scene.size.width / 1.25 / 2,
            y: -scene.size.height / 1.25 / 2,
            width: scene.size.width / 1.25,
            height: scene.size.height / 1.25
        ), cornerRadius: 14);
        backgroundNode.zPosition = 95;
        backgroundNode.lineWidth = 0;
        backgroundNode.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.8);
        backgroundNode.isHidden = true;
        scene.camera?.addChild(backgroundNode);
        
        closeLabel.position = CGPoint(x: (scene.size.width / 1.25 / 2) - 15, y: (scene.size.height / 1.25 / 2) - 30);
        closeLabel.zPosition = 100;
        closeLabel.text = "Close";
        closeLabel.fontColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1);
        closeLabel.fontName = "ChalkboardSE-Bold";
        closeLabel.fontSize = 25;
        closeLabel.horizontalAlignmentMode = .right;
        closeLabel.isHidden = true;
        scene.camera?.addChild(closeLabel);
        closeLabelBackground = SKShapeNode(rect: CGRect(
            x: -closeLabel.frame.width,
            y: -3,
            width: closeLabel.frame.width,
            height: closeLabel.frame.height
        ), cornerRadius: 5);
        closeLabelBackground.lineWidth = 10;
        closeLabelBackground.fillColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
        closeLabelBackground.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1);
        closeLabel.addChild(closeLabelBackground);
        
        titleLabel.position = CGPoint(x: 0, y: scene.size.height / 3);
        titleLabel.zPosition = 100;
        titleLabel.text = "City Shop";
        titleLabel.fontColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1);
        titleLabel.fontName = "ChalkboardSE-Bold";
        titleLabel.fontSize = 30;
        titleLabel.isHidden = true;
        scene.camera?.addChild(titleLabel);
        
        for i in 0..<shopTabs.count {
            let tabLabel = SKLabelNode();
            tabLabel.text = shopTabs[i];
            tabLabel.position = CGPoint(
                x: CGFloat((i - 1)) * (scene.size.width / 4) + 4,
                y: scene.size.height / 5
            );
            tabLabel.zPosition = 100;
            tabLabel.fontColor = unselectedTabTextColor;
            tabLabel.fontName = "ChalkboardSE-Bold";
            tabLabel.fontSize = 23;
            tabLabel.horizontalAlignmentMode = .center;
            tabLabel.isHidden = true;
            scene.camera?.addChild(tabLabel);
            bodyTabLabels.append(tabLabel);
        }
        
        updateSelectedTab(0);
    }
    
    //update the tab labels to the currently selected one
    func updateSelectedTab(_ index: Int) {
        currentTabIndex = index;
        scrollNode.scrollTo(CGPoint(x: 0, y: 0), animated: false);
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].fontSize = (i == currentTabIndex ? 30 : 23);
            bodyTabLabels[i].fontColor = (i == currentTabIndex ? selectedTabTextColor : unselectedTabTextColor);
        }
        
        scrollNode.removeAllChildren();
        
        if(currentTabIndex == 0) {
            let scrollNode1 = SKSpriteNode(color: .green, size: CGSize(width: scrollNode.scrollView.frame.width, height: 100));
            scrollNode1.position = CGPoint.zero;
            scrollNode.addChild(scrollNode1);
        }
        else if(currentTabIndex == 1) {
            let scrollNode1 = SKSpriteNode(color: .blue, size: CGSize(width: scrollNode.scrollView.frame.width, height: 100));
            scrollNode1.position = CGPoint.zero;
            scrollNode.addChild(scrollNode1);
        }
        else if(currentTabIndex == 2) {
            let scrollNode1 = SKSpriteNode(color: .red, size: CGSize(width: scrollNode.scrollView.frame.width, height: 100));
            scrollNode1.position = CGPoint.zero;
            scrollNode.addChild(scrollNode1);
        }
    }
    
    func showMenu() {
        backgroundNode.isHidden = false;
        closeLabel.isHidden = false;
        titleLabel.isHidden = false;
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].isHidden = false;
        }
        
        scrollNode.setHidden(false);
    }
    
    func hideMenu() {
        backgroundNode.isHidden = true;
        closeLabel.isHidden = true;
        titleLabel.isHidden = true;
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].isHidden = true;
        }
        
        scrollNode.setHidden(true);
    }
}
