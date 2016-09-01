//
//  GameScene.swift
//  BitmapFont-Example
//
//  Created by René BIGOT on 29/08/2016.
//  Copyright (c) 2016 BRAE. All rights reserved.
//
// Bitmap font generated with http://kvazars.com/littera/


import SpriteKit
import BitmapFont

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let _xmlPath = NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "XML-Font")!

        let font40 = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 40)
        let node40 = font40.nodeForText("Ta Justified text: Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nUt sit amet felis ut eros eleifend tincidunt.", alignment: .Justified, boundingRect: CGRect(x: 0, y: CGRectGetMaxY(self.frame), width: 1024, height: 250))
        self.addChild(node40)

        let font30 = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 30)
        let node30 = font30.nodeForText("Left aligned text: Lorem ipsum dolor sit amet, consectetur adipiscing elit.", alignment: .Left, boundingRect: CGRect(x: 0, y: CGRectGetMaxY(self.frame) - 260, width: 1024, height: 100))
        self.addChild(node30)

        let font50 = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 50)
        let node50 = font50.nodeForText("Right aligned text: Lorem ipsum dolor sit amet, consectetur adipiscing elit.", alignment: .Right, boundingRect: CGRect(x: 0, y: CGRectGetMaxY(self.frame) - 360, width: 1024, height: 170))
        self.addChild(node50)

        let font35 = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 35)
        let node35 = font35.nodeForText("Centered text: Lorem ipsum dolor sit amet, consectetur adipiscing elit.\nUt sit amet felis ut eros eleifend tincidunt.", alignment: .Center, boundingRect: CGRect(x: 0, y: CGRectGetMaxY(self.frame) - 600, width: 512, height: 160))
        self.addChild(node35)

        node35.children.forEach { (node) in
            if node.name == "e" || node.name == "E" {
                node.runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.fadeAlphaTo(0.5, duration: 0.1),
                    SKAction.fadeAlphaTo(1, duration: 0.1)
                    ])))
            }
        }

        self.backgroundColor = SKColor(deviceRed: 151/255, green: 222/255, blue: 255/255, alpha: 1)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let location = theEvent.locationInNode(self)
        
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.position = location;
        sprite.setScale(0.5)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        self.addChild(sprite)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
