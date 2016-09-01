//
//  File.swift
//  BitmapFont
//
//  Created by René BIGOT on 31/08/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//

import Foundation
import SpriteKit
import XCTest

@testable import BitmapFont

class XmlParserTests: XCTestCase {
    var _xmlParser: XmlBitmapFontParser?
    
    override func setUp() {
        super.setUp()

        _xmlParser = XmlBitmapFontParser()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBitmapFontInfo() {
        var xml = "<font><info face=\"font-name\" size=\"123\" bold=\"1\" italic=\"1\" charset=\"UTF-8\" unicode=\"1\" stretchH=\"99\" smooth=\"1\" aa=\"1\" padding=\"1,2,3,4\" spacing=\"1,2\" outline=\"1\"/></font>"

        _xmlParser!.parse(xml)

        XCTAssertEqual(_xmlParser?.info?.face, "font-name")
        XCTAssertEqual(_xmlParser?.info?.size, 123)
        XCTAssertEqual(_xmlParser?.info?.bold, true)
        XCTAssertEqual(_xmlParser?.info?.italic, true)
        XCTAssertEqual(_xmlParser?.info?.charset, "UTF-8")
        XCTAssertEqual(_xmlParser?.info?.unicode, true)
        XCTAssertEqual(_xmlParser?.info?.stretchH, 99)
        XCTAssertEqual(_xmlParser?.info?.smooth, true)
        XCTAssertEqual(_xmlParser?.info?.aa, 1)
        XCTAssert((_xmlParser!.info?.padding)! == Padding(top: 1, bottom: 3, left: 4, right: 2))
        XCTAssert((_xmlParser!.info?.spacing)! == Spacing(horizontal: 1, vertical: 2))
        XCTAssertEqual(_xmlParser?.info?.outline, 1)

        xml = "<font><info face=\"font-name\" size=\"123\" bold=\"0\" italic=\"0\" charset=\"UTF-8\" unicode=\"0\" stretchH=\"99\" smooth=\"0\" aa=\"1\" padding=\"\" spacing=\"\" outline=\"1\"/></font>"

        _xmlParser!.parse(xml)
        XCTAssertEqual(_xmlParser?.info?.bold, false)
        XCTAssertEqual(_xmlParser?.info?.italic, false)
        XCTAssertEqual(_xmlParser?.info?.unicode, false)
        XCTAssertEqual(_xmlParser?.info?.smooth, false)
        XCTAssert((_xmlParser!.info?.padding)! == Padding(top: 0, bottom: 0, left: 0, right: 0))
        XCTAssert((_xmlParser!.info?.spacing)! == Spacing(horizontal: 0, vertical: 0))
    }

    func testBitmapFontCommon() {
        var xml = "<font><common lineHeight=\"80\" base=\"57\" scaleW=\"739\" scaleH=\"512\" pages=\"3\" packed=\"0\"/></font>"

        _xmlParser!.parse(xml)
        XCTAssertEqual(_xmlParser?.common?.lineHeight, 80)
        XCTAssertEqual(_xmlParser?.common?.base, 57)
        XCTAssertEqual(_xmlParser?.common?.scaleW, 739)
        XCTAssertEqual(_xmlParser?.common?.scaleH, 512)
        XCTAssertEqual(_xmlParser?.common?.pages, 3)
        XCTAssertEqual(_xmlParser?.common?.packed, false)

        xml = "<font><common lineHeight=\"80\" base=\"57\" scaleW=\"739\" scaleH=\"512\" pages=\"3\" packed=\"1\"/></font>"

        _xmlParser!.parse(xml)
        XCTAssertEqual(_xmlParser?.common?.packed, true)
}

    func testBitmapFontPage() {
        let directory = (NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "XML-Font")! as NSString).stringByDeletingLastPathComponent
        let xml = "<font><pages><page id=\"0\" file=\"font.png\"/><page id=\"3\" file=\"font.png\"/></pages></font>"

        _xmlParser!._directory = directory

        _xmlParser!.parse(xml)
        XCTAssertEqual(_xmlParser?.pages?.count, 2)
        XCTAssertEqual(_xmlParser?.pages?[0].id, 0)
        XCTAssertEqual(_xmlParser?.pages?[0].texture.size().width, 739)
        XCTAssertEqual(_xmlParser?.pages?[0].texture.size().height, 512)

        XCTAssertEqual(_xmlParser?.pages?[1].id, 3)
        XCTAssertEqual(_xmlParser?.pages?[1].texture.size().width, 739)
        XCTAssertEqual(_xmlParser?.pages?[1].texture.size().height, 512)
    }

    func testBitmapFontCharacter() {
        let xml = "<font>"
         + "<chars count=\"5\">"
         + "<char id=\"65\" x=\"11\" y=\"22\" width=\"12\" height=\"34\" xoffset=\"5\" yoffset=\"-6\" xadvance=\"78\" page=\"0\" chnl=\"1\"/>"
         + "<char id=\"66\" x=\"10\" y=\"20\" width=\"17\" height=\"61\" xoffset=\"1\" yoffset=\"4\" xadvance=\"20\" page=\"1\" chnl=\"2\"/>"
         + "<char id=\"67\" x=\"10\" y=\"91\" width=\"27\" height=\"28\" xoffset=\"-1\" yoffset=\"4\" xadvance=\"26\" page=\"0\" chnl=\"4\"/>"
         + "<char id=\"68\" x=\"37\" y=\"10\" width=\"47\" height=\"62\" xoffset=\"-3\" yoffset=\"4\" xadvance=\"40\" page=\"0\" chnl=\"8\"/>"
         + "<char id=\"69\" x=\"10\" y=\"129\" width=\"42\" height=\"72\" xoffset=\"-1\" yoffset=\"0\" xadvance=\"40\" page=\"0\" chnl=\"15\"/>"
         + "</chars>"
         + "</font>"

        _xmlParser!.parse(xml)
        XCTAssertEqual(_xmlParser?.characters?.count, 5)

        XCTAssertEqual(_xmlParser?.characters!["A"]?.id, 65)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.x, 11)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.y, 22)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.width, 12)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.height, 34)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.xoffset, 5)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.yoffset, -6)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.xadvance, 78)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.page, 0)
        XCTAssertEqual(_xmlParser?.characters!["A"]?.chnl, ColorChannel.blue)

        XCTAssertEqual(_xmlParser?.characters!["B"]?.page, 1)
        XCTAssertEqual(_xmlParser?.characters!["B"]?.chnl, ColorChannel.green)

        XCTAssertEqual(_xmlParser?.characters!["C"]?.chnl, ColorChannel.red)

        XCTAssertEqual(_xmlParser?.characters!["D"]?.chnl, ColorChannel.alpha)

        XCTAssertEqual(_xmlParser?.characters!["E"]?.chnl, ColorChannel.all)
    }

    func testBitmapFontKerning() {
        let xml = "<font>"
            + "<kernings count=\"3\">"
            + "<kerning first=\"65\" second=\"71\" amount=\"-4\"/>"
            + "<kerning first=\"65\" second=\"72\" amount=\"-6\"/>"
            + "<kerning first=\"66\" second=\"72\" amount=\"-1\"/>"
            + "</kernings>"
            + "</font>"

        _xmlParser!.parse(xml)
        XCTAssertEqual(_xmlParser?.kernings?.count, 2)

        var kernings = _xmlParser?.kernings!["A"]
        XCTAssertEqual(kernings?.count, 2)

        var kerning = kernings![0]
        XCTAssertEqual(kerning.first, "A")
        XCTAssertEqual(kerning.second, "G")
        XCTAssertEqual(kerning.amount, -4)

        kerning = kernings![1]
        XCTAssertEqual(kerning.first, "A")
        XCTAssertEqual(kerning.second, "H")
        XCTAssertEqual(kerning.amount, -6)

        kernings = _xmlParser?.kernings!["B"]
        XCTAssertEqual(kernings?.count, 1)

        kerning = kernings![0]
        XCTAssertEqual(kerning.first, "B")
        XCTAssertEqual(kerning.second, "H")
        XCTAssertEqual(kerning.amount, -1)
    }

    func testClassInit() {
        let parser = XmlBitmapFontParser(filePath: NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "XML-Font")!)
        XCTAssertNotNil(parser)
    }
}
