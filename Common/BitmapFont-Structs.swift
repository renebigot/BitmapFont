//
//  BitmapFont-Structs.swift
//  BitmapFont
//
//  Created by René BIGOT on 30/08/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//

import Foundation
import SpriteKit

enum ColorChannel {
    case blue
    case green
    case red
    case alpha
    case all
}

struct Padding {
    var top: CGFloat
    var bottom: CGFloat
    var left: CGFloat
    var right: CGFloat
}

func ==(lhs: Padding, rhs: Padding) -> Bool {
    return lhs.top == rhs.top && lhs.bottom == rhs.bottom && lhs.left == rhs.left && lhs.right == rhs.right
}

struct Spacing {
    var horizontal: CGFloat
    var vertical: CGFloat
}

func ==(lhs: Spacing, rhs: Spacing) -> Bool {
    return lhs.horizontal == rhs.horizontal && lhs.vertical == rhs.vertical
}


struct BitmapFontInfo {
    var face: String
    var size: CGFloat
    var bold: Bool
    var italic: Bool
    var charset: String
    var unicode: Bool
    var stretchH: CGFloat
    var smooth: Bool
    var aa: Int
    var padding: Padding
    var spacing: Spacing
    var outline: CGFloat
}

struct BitmapFontPage {
    var id: Int
    var texture: SKTexture
}

struct BitmapFontCharacter {
    var id: Int
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var xoffset: CGFloat
    var yoffset: CGFloat
    var xadvance: CGFloat
    var page: Int
    var chnl: ColorChannel
}

struct BitmapFontKerning {
    var first: Character
    var second: Character
    var amount: CGFloat
}

struct BitmapFontCommon {
    var lineHeight: CGFloat
    var base: CGFloat
    var scaleW: CGFloat
    var scaleH: CGFloat
    var pages: Int
    var packed: Bool
}

