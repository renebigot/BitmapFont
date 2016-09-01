//
//  BitmapFontTests.swift
//  BitmapFontTests
//
//  Created by René BIGOT on 21/07/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//

import SpriteKit
import XCTest

@testable import BitmapFont

class BitmapFontTests: XCTestCase {
    var _xmlPath = ""
    var _txtPath = ""

    override func setUp() {
        super.setUp()

        _xmlPath = NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "XML-Font")!
        _txtPath = NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "TXT-Font")!
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testParseXml() {
        let font = BitmapFont()
        font.parseXml(at: _xmlPath)
        XCTAssertNotNil(font._parser)
    }

    func testParseTxt() {
        let font = BitmapFont()
        font.parseTxt(at: _txtPath)
        XCTAssertNotNil(font._parser)
    }

    func testParseCommon() {
        let font = BitmapFont()
        font.parseXml(at: _xmlPath)

        font.parseCommon()

        XCTAssertEqual(font.common!.lineHeight, 80)
        XCTAssertEqual(font.common!.base, 57)
        XCTAssertEqual(font.common!.scaleW, 739)
        XCTAssertEqual(font.common!.scaleH, 512)
    }

    func testParseFontInfo() {
        let font = BitmapFont()
        font.parseXml(at: _xmlPath)

        font.parseInfo(72)

        XCTAssertEqual(font.info!.face, "font")
        XCTAssertEqual(font.info!.size, 72)
        XCTAssertEqual(font.info!.bold, false)
        XCTAssertEqual(font.info!.italic, false)
        XCTAssertEqual(font.info!.charset, "")
        XCTAssertEqual(font.info!.unicode, false)
        XCTAssertEqual(font.info!.stretchH, 100)
        XCTAssertEqual(font.info!.smooth, true)
        XCTAssertEqual(font.info!.aa, 1)
        XCTAssert(font.info!.padding == Padding(top: 10, bottom: 10, left: 10, right: 10))
        XCTAssert(font.info!.spacing == Spacing(horizontal: 0, vertical: 0))
        XCTAssertEqual(font.info!.outline, 0)
    }

    func testParsePages() {
        let font = BitmapFont()
        font.parseXml(at: _xmlPath)

        font.parsePages()

        XCTAssertEqual(font.pages!.count, 1)
        XCTAssertEqual(font.pages![0].id, 0)
    }

    func testParseKernings() {
        let font = BitmapFont()
        font.parseXml(at: _xmlPath)

        font.parseKernings()

        XCTAssertEqual(font.kernings!.count, 16)
        XCTAssertEqual(font.kernings![" "]!.count, 3)
        XCTAssertEqual(font.kernings![" "]![0].first, " ")
        XCTAssertEqual(font.kernings![" "]![0].second, "A")
        XCTAssertEqual(font.kernings![" "]![0].amount, -4)
    }

    func testParseCharacters() {
        let font = BitmapFont()
        font.parseXml(at: _xmlPath)

        font.parseKernings()
        font.parseCharacters()

        XCTAssertEqual(font.characters!.count, 95)
        XCTAssertEqual(font.characters!["X"]!.id, 88)
        XCTAssertEqual(font.characters!["X"]!.x, 424)
        XCTAssertEqual(font.characters!["X"]!.y, 151)
        XCTAssertEqual(font.characters!["X"]!.width, 53)
        XCTAssertEqual(font.characters!["X"]!.height, 61)
        XCTAssertEqual(font.characters!["X"]!.xoffset, -3)
        XCTAssertEqual(font.characters!["X"]!.yoffset, 4)
        XCTAssertEqual(font.characters!["X"]!.xadvance, 48)
        XCTAssertEqual(font.characters!["X"]!.page, 0)
        XCTAssertEqual(font.characters!["X"]!.chnl, ColorChannel.all)
    }

    func testSingleLineTextSize() {
        var font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 144)

        var fontSize = font.sizeForText("Test")
        XCTAssertEqual(fontSize.width, 268)
        XCTAssertEqual(fontSize.height, 160)

        font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 36)
        fontSize = font.sizeForText("Test")
        XCTAssertEqual(fontSize.width, 67)
        XCTAssertEqual(fontSize.height, 40)
    }

    func testMultiLinesTextSize() {
        var font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 144)

        var fontSize = font.sizeForText("Test\nwith multiple\nlines" )
        XCTAssertEqual(fontSize.width, 798)
        XCTAssertEqual(fontSize.height, 480)

        fontSize = font.sizeForText("Test\rwith multiple\rlines" )
        XCTAssertEqual(fontSize.width, 798)
        XCTAssertEqual(fontSize.height, 480)

        fontSize = font.sizeForText("Test\r\nwith multiple\r\nlines" )
        XCTAssertEqual(fontSize.width, 798)
        XCTAssertEqual(fontSize.height, 480)

        fontSize = font.sizeForText("Test\n\rwith multiple\n\rlines" )
        XCTAssertEqual(fontSize.width, 798)
        XCTAssertEqual(fontSize.height, 480)

        fontSize = font.sizeForText("Test\n\nwith multiple\n\nlines\n" )
        XCTAssertEqual(fontSize.width, 798)
        XCTAssertEqual(fontSize.height, 960)



        font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 36)
        fontSize = font.sizeForText("Test\nwith multiple\nlines")
        XCTAssertEqual(fontSize.width, 199.5)
        XCTAssertEqual(fontSize.height, 120)

        fontSize = font.sizeForText("Test\rwith multiple\rlines")
        XCTAssertEqual(fontSize.width, 199.5)
        XCTAssertEqual(fontSize.height, 120)

        fontSize = font.sizeForText("Test\r\nwith multiple\r\nlines")
        XCTAssertEqual(fontSize.width, 199.5)
        XCTAssertEqual(fontSize.height, 120)

        fontSize = font.sizeForText("Test\n\rwith multiple\n\rlines")
        XCTAssertEqual(fontSize.width, 199.5)
        XCTAssertEqual(fontSize.height, 120)
        
        fontSize = font.sizeForText("Test\n\nwith multiple\n\nlines\n")
        XCTAssertEqual(fontSize.width, 199.5)
        XCTAssertEqual(fontSize.height, 240)
    }

    func testCreateNode() {
        let font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 72)

        let node = font.nodeForText("Test\n\nwith multiple\n|\nlines\n")
        XCTAssertEqual(node.children.count, 23)
        XCTAssertEqual(node.size.height, 386)
        XCTAssertEqual(node.size.width, 401)
    }

    func testCreateNodeWithAlignment() {
        let font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 72)

        var node = font.nodeForText("Test\n\nwith multiple\n|\nlines\n", alignment: .Left)
        XCTAssertEqual(node.children[0].position.x, 0)
        XCTAssertEqual(node.children[4].position.x, 0)
        XCTAssertEqual(node.children[17].position.x, 0)
        XCTAssertEqual(node.children[18].position.x, 0)

        node = font.nodeForText("Test\n\nwith multiple\n|\nlines\n", alignment: .Right)
        XCTAssertEqual(node.children[3].position.x, 376)
        XCTAssertEqual(node.children[16].position.x, 358)
        XCTAssertEqual(node.children[17].position.x, 382)
        XCTAssertEqual(node.children[22].position.x, 361)

        node = font.nodeForText("Test\n\nwith multiple\n|\nlines\n", alignment: .Center)
        XCTAssertEqual(node.children[0].position.x, 132.5)
        XCTAssertEqual(node.children[4].position.x, 0)
        XCTAssertEqual(node.children[17].position.x, 191)
        XCTAssertEqual(node.children[18].position.x, 125.5)
    }

    func testCreateNodeWithBoundingRect() {
        let font = BitmapFont(withXmlFileAt:_xmlPath, fontSize: 72)

        let node = font.nodeForText("Test\n\nwith multiple\n|\nlines\n", alignment: .Justified, boundingRect: CGRect(x: 11, y: 22, width: 260, height: 1000))
        XCTAssertEqual(node.position.x, 11)
        XCTAssertEqual(node.position.y, 22)
        XCTAssertEqual(node.size.width, 260)
        XCTAssertEqual(node.size.height, 466)

        XCTAssertEqual(node.children[4].position.x, 0)
        XCTAssertEqual(node.children[7].position.x, node.size.width - (node.children[7] as! SKSpriteNode).size.width)
    }
}
