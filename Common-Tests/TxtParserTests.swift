//
//  TxtParserTests.swift
//
//  BitmapFont
//
//  Created by René BIGOT on 31/08/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//

import Foundation
import SpriteKit
import XCTest

@testable import BitmapFont

class TxtParserTests: XCTestCase {
    var _txtParser: TxtBitmapFontParser?

    override func setUp() {
        super.setUp()

        _txtParser = TxtBitmapFontParser()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBitmapFontInfo() {
        var txt = "font\ninfo face=\"font-name\" size=\"123\" bold=\"1\" italic=\"1\" charset=\"UTF-8\" unicode=\"1\" stretchH=\"99\" smooth=\"1\" aa=\"1\" padding=\"1,2,3,4\" spacing=\"1,2\" outline=\"1\"\n"

        _txtParser!.parse(txt)

        XCTAssertEqual(_txtParser?.info?.face, "font-name")
        XCTAssertEqual(_txtParser?.info?.size, 123)
        XCTAssertEqual(_txtParser?.info?.bold, true)
        XCTAssertEqual(_txtParser?.info?.italic, true)
        XCTAssertEqual(_txtParser?.info?.charset, "UTF-8")
        XCTAssertEqual(_txtParser?.info?.unicode, true)
        XCTAssertEqual(_txtParser?.info?.stretchH, 99)
        XCTAssertEqual(_txtParser?.info?.smooth, true)
        XCTAssertEqual(_txtParser?.info?.aa, 1)
        XCTAssert((_txtParser!.info?.padding)! == Padding(top: 1, bottom: 3, left: 4, right: 2))
        XCTAssert((_txtParser!.info?.spacing)! == Spacing(horizontal: 1, vertical: 2))
        XCTAssertEqual(_txtParser?.info?.outline, 1)

        txt = "font\ninfo face=\"font-name\" size=\"123\" bold=\"0\" italic=\"0\" charset=\"UTF-8\" unicode=\"0\" stretchH=\"99\" smooth=\"0\" aa=\"1\" padding=\"\" spacing=\"\" outline=\"1\"\n"

        _txtParser!.parse(txt)
        XCTAssertEqual(_txtParser?.info?.bold, false)
        XCTAssertEqual(_txtParser?.info?.italic, false)
        XCTAssertEqual(_txtParser?.info?.unicode, false)
        XCTAssertEqual(_txtParser?.info?.smooth, false)
        XCTAssert((_txtParser!.info?.padding)! == Padding(top: 0, bottom: 0, left: 0, right: 0))
        XCTAssert((_txtParser!.info?.spacing)! == Spacing(horizontal: 0, vertical: 0))
    }

    func testBitmapFontCommon() {
        var txt = "font\ncommon lineHeight=\"80\" base=\"57\" scaleW=\"739\" scaleH=\"512\" pages=\"3\" packed=\"0\"\n"

        _txtParser!.parse(txt)
        XCTAssertEqual(_txtParser?.common?.lineHeight, 80)
        XCTAssertEqual(_txtParser?.common?.base, 57)
        XCTAssertEqual(_txtParser?.common?.scaleW, 739)
        XCTAssertEqual(_txtParser?.common?.scaleH, 512)
        XCTAssertEqual(_txtParser?.common?.pages, 3)
        XCTAssertEqual(_txtParser?.common?.packed, false)

        txt = "font\ncommon lineHeight=\"80\" base=\"57\" scaleW=\"739\" scaleH=\"512\" pages=\"3\" packed=\"1\"\n"

        _txtParser!.parse(txt)
        XCTAssertEqual(_txtParser?.common?.packed, true)
    }

    func testBitmapFontPage() {
        let directory = (NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "TXT-Font")! as NSString).stringByDeletingLastPathComponent
        let txt = "font\npages\npage id=\"0\" file=\"font.png\"\npage id=\"3\" file=\"font.png\"\n"

        _txtParser!._directory = directory

        _txtParser!.parse(txt)
        XCTAssertEqual(_txtParser?.pages?.count, 2)
        XCTAssertEqual(_txtParser?.pages?[0].id, 0)
        XCTAssertEqual(_txtParser?.pages?[0].texture.size().width, 739)
        XCTAssertEqual(_txtParser?.pages?[0].texture.size().height, 512)

        XCTAssertEqual(_txtParser?.pages?[1].id, 3)
        XCTAssertEqual(_txtParser?.pages?[1].texture.size().width, 739)
        XCTAssertEqual(_txtParser?.pages?[1].texture.size().height, 512)
    }

    func testBitmapFontCharacter() {
        let txt = "font\n"
            + "chars count=\"5\"\n"
            + "char id=\"65\" x=\"11\" y=\"22\" width=\"12\" height=\"34\" xoffset=\"5\" yoffset=\"-6\" xadvance=\"78\" page=\"0\" chnl=\"1\"\n"
            + "char id=\"66\" x=\"10\" y=\"20\" width=\"17\" height=\"61\" xoffset=\"1\" yoffset=\"4\" xadvance=\"20\" page=\"1\" chnl=\"2\"\n"
            + "char id=\"67\" x=\"10\" y=\"91\" width=\"27\" height=\"28\" xoffset=\"-1\" yoffset=\"4\" xadvance=\"26\" page=\"0\" chnl=\"4\"\n"
            + "char id=\"68\" x=\"37\" y=\"10\" width=\"47\" height=\"62\" xoffset=\"-3\" yoffset=\"4\" xadvance=\"40\" page=\"0\" chnl=\"8\"\n"
            + "char id=\"69\" x=\"10\" y=\"129\" width=\"42\" height=\"72\" xoffset=\"-1\" yoffset=\"0\" xadvance=\"40\" page=\"0\" chnl=\"15\"\n"

        _txtParser!.parse(txt)
        XCTAssertEqual(_txtParser?.characters?.count, 5)

        XCTAssertEqual(_txtParser?.characters!["A"]?.id, 65)
        XCTAssertEqual(_txtParser?.characters!["A"]?.x, 11)
        XCTAssertEqual(_txtParser?.characters!["A"]?.y, 22)
        XCTAssertEqual(_txtParser?.characters!["A"]?.width, 12)
        XCTAssertEqual(_txtParser?.characters!["A"]?.height, 34)
        XCTAssertEqual(_txtParser?.characters!["A"]?.xoffset, 5)
        XCTAssertEqual(_txtParser?.characters!["A"]?.yoffset, -6)
        XCTAssertEqual(_txtParser?.characters!["A"]?.xadvance, 78)
        XCTAssertEqual(_txtParser?.characters!["A"]?.page, 0)
        XCTAssertEqual(_txtParser?.characters!["A"]?.chnl, ColorChannel.blue)

        XCTAssertEqual(_txtParser?.characters!["B"]?.page, 1)
        XCTAssertEqual(_txtParser?.characters!["B"]?.chnl, ColorChannel.green)

        XCTAssertEqual(_txtParser?.characters!["C"]?.chnl, ColorChannel.red)

        XCTAssertEqual(_txtParser?.characters!["D"]?.chnl, ColorChannel.alpha)

        XCTAssertEqual(_txtParser?.characters!["E"]?.chnl, ColorChannel.all)
    }

    func testBitmapFontKerning() {
        let txt = "font\n"
            + "kernings count=\"3\"\n"
            + "kerning first=\"65\" second=\"71\" amount=\"-4\"\n"
            + "kerning first=\"65\" second=\"72\" amount=\"-6\"\n"
            + "kerning first=\"66\" second=\"72\" amount=\"-1\"\n"

        _txtParser!.parse(txt)
        XCTAssertEqual(_txtParser?.kernings?.count, 2)

        var kernings = _txtParser?.kernings!["A"]
        XCTAssertEqual(kernings?.count, 2)

        var kerning = kernings![0]
        XCTAssertEqual(kerning.first, "A")
        XCTAssertEqual(kerning.second, "G")
        XCTAssertEqual(kerning.amount, -4)

        kerning = kernings![1]
        XCTAssertEqual(kerning.first, "A")
        XCTAssertEqual(kerning.second, "H")
        XCTAssertEqual(kerning.amount, -6)

        kernings = _txtParser?.kernings!["B"]
        XCTAssertEqual(kernings?.count, 1)

        kerning = kernings![0]
        XCTAssertEqual(kerning.first, "B")
        XCTAssertEqual(kerning.second, "H")
        XCTAssertEqual(kerning.amount, -1)
    }
    
    func testClassInit() {
        let parser = TxtBitmapFontParser(filePath: NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "TXT-Font")!)
        XCTAssertNotNil(parser)
    }
}
