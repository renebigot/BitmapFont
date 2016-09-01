//
//  BitmapFontParser.swift
//  BitmapFont
//
//  Created by René BIGOT on 31/08/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//

import Foundation
import SpriteKit

#if os(iOS)
    import UIKit
#endif

public class BitmapFontParser: NSObject {
    var info: BitmapFontInfo?
    var common: BitmapFontCommon?
    var pages: [BitmapFontPage]?
    var characters: [Character: BitmapFontCharacter]?
    var kernings: [Character: [BitmapFontKerning]]?

    var _directory = ""

    public convenience init(filePath: String) {
        self.init()

        var fileContent = ""
        do {
            fileContent = try String.init(contentsOfFile: filePath)
        } catch {
        }

        _directory = (filePath as NSString).stringByDeletingLastPathComponent

        parse(fileContent)
    }

    public func parse(filePath: String) {
        assert(false, "parse(filePath:) must be overriden")
    }

    func BoolFromString(string: String) -> Bool {
        return (string as NSString).boolValue
    }

    func IntFromString(string: String) -> Int {
        return (string as NSString).integerValue
    }

    func CGFloatFromString(string: String) -> CGFloat {
        return CGFloat((string as NSString).floatValue)
    }

    func PaddingFromString(string: String) -> Padding {
        let padding = string.componentsSeparatedByString(",")

        if (padding.count == 4) {
            return Padding(top: CGFloatFromString(padding[0]), bottom: CGFloatFromString(padding[2]), left: CGFloatFromString(padding[3]), right: CGFloatFromString(padding[1]))
        }

        return Padding(top: 0, bottom: 0, left: 0, right: 0)
    }

    func SpacingFromString(string: String) -> Spacing {
        let spacing = string.componentsSeparatedByString(",")

        if (spacing.count == 2) {
            return Spacing(horizontal: CGFloatFromString(spacing[0]), vertical: CGFloatFromString(spacing[1]))
        }

        return Spacing(horizontal: 0, vertical: 0)
    }

    func ColorChannelFromString(string: String) -> ColorChannel {
        switch (string) {
        case "1":
            return ColorChannel.blue
        case "2":
            return ColorChannel.green
        case "4":
            return ColorChannel.red
        case "8":
            return ColorChannel.alpha
        default:
            return ColorChannel.all
        }
    }
}