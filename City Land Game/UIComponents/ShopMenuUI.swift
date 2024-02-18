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
    
    let shopTabs: [String] = ["Production", "Defenses", "Decorations"];
    
    var scrollView: SwiftySKScrollView?;
    var movableScrollNode = SKNode();

    var scene: SKScene;
    
    init(_ scene: SKScene) {
        self.scene = scene;
    }
    
    func setupMenu() {
        let cropNode = SKCropNode();
        let cropMaskNode = SKSpriteNode(color: .yellow, size: CGSize(width: scene.size.width / 1.5, height: scene.size.height / 1.5));
        cropNode.maskNode = cropMaskNode;
        cropNode.position = CGPoint.zero;
        cropNode.zPosition = 105;
        cropNode.addChild(movableScrollNode);
        scene.camera?.addChild(cropNode);
        
        let scrollViewFrame = CGRect(x: 0, y: 0, width: scene.size.width / 1.5, height: scene.size.height / 1.5);
        scrollView = SwiftySKScrollView(
            frame: scrollViewFrame,
            moveableNode: movableScrollNode,
            direction: .vertical
        );
        guard let scrollView = scrollView else { return; }
        scrollView.contentSize = CGSize(width: scrollViewFrame.width, height: scrollViewFrame.height * 5);
        scrollView.center = CGPoint(x: scene.frame.midX, y: scene.frame.midY);
        scrollView.contentOffset = CGPoint(x: 0, y: 10);
        scrollView.isDisabled = true;
        scrollView.isHidden = true;
        scrollView.showsVerticalScrollIndicator = true;
        scene.view?.addSubview(scrollView);
        
        movableScrollNode.isHidden = true;
        
        let scrollNode1 = SKSpriteNode(color: .red, size: CGSize(width: 300, height: 100));
        scrollNode1.position = CGPoint.zero;
        movableScrollNode.addChild(scrollNode1);
        
        
//        scene.camera?.addChild(movableNode);
//        movableNode.zPosition = 101;
//        scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: 0, width: scene.size.width, height: scene.size.height), moveableNode: movableNode, direction: .vertical);
//        scrollView?.contentSize = CGSize(width: scrollView!.frame.width, height: scrollView!.frame.height * 3); // makes it 3 times the height
//        //scrollView?.backgroundColor = .blue;
//        scrollView?.center = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
//        scene.view?.addSubview(scrollView!);
//        scrollView?.isDisabled = true;
//        scrollView?.isHidden = true;
//        scrollView?.showsVerticalScrollIndicator = true;
//        
//        guard let scrollView = scrollView else { return } // unwrap  optional
//
//        let page1ScrollView = SKSpriteNode(color: .red, size: CGSize(width: 100, height: 100))
//        page1ScrollView.zPosition = 105;
//        page1ScrollView.position = CGPoint(x: 0, y: 0)
//        movableNode.addChild(page1ScrollView)
//                
//        let page2ScrollView = SKSpriteNode(color: .yellow, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height / 3))
//        page2ScrollView.position = CGPoint(x: 0, y: scene.frame.midY)
//        movableNode.addChild(page2ScrollView)
//                
//        let page3ScrollView = SKSpriteNode(color: .green, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height / 3))
//        page3ScrollView.position = CGPoint(x: 0, y: scene.frame.midY)
//        movableNode.addChild(page3ScrollView)
        
        
        
        
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
            tabLabel.fontColor = #colorLiteral(red: 0.3755322002, green: 0.4041152226, blue: 0.4470713507, alpha: 1);
            tabLabel.fontName = "ChalkboardSE-Bold";
            tabLabel.fontSize = 25;
            tabLabel.horizontalAlignmentMode = .center;
            tabLabel.isHidden = true;
            scene.camera?.addChild(tabLabel);
            bodyTabLabels.append(tabLabel);
        }
    }
    
    func showMenu() {
        backgroundNode.isHidden = false;
        closeLabel.isHidden = false;
        titleLabel.isHidden = false;
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].isHidden = false;
        }
        
        scrollView?.isDisabled = false;
        scrollView?.isHidden = false;
        movableScrollNode.isHidden = false;
    }
    
    func hideMenu() {
        backgroundNode.isHidden = true;
        closeLabel.isHidden = true;
        titleLabel.isHidden = true;
        
        for i in 0..<bodyTabLabels.count {
            bodyTabLabels[i].isHidden = true;
        }
        
        scrollView?.isDisabled = true;
        scrollView?.isHidden = true;
        movableScrollNode.isHidden = true;
    }
}
