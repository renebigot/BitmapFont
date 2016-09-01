//
//  TxtBitmapFontParser.swift
//  BitmapFont
//
//  Created by René BIGOT on 01/09/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//
// File description can be found at: http://www.angelcode.com/products/bmfont/doc/file_format.html

import Foundation
import SpriteKit

#if os(iOS)
    import UIKit
#endif

public class TxtBitmapFontParser: BitmapFontParser {

    public override func parse(fileContent: String) {
        let lines = fileContent.stringByReplacingOccurrencesOfString("\r\n", withString: "\n")
            .stringByReplacingOccurrencesOfString("\n\r", withString: "\n")
            .stringByReplacingOccurrencesOfString("\r", withString: "\n").componentsSeparatedByString("\n")

        lines.forEach { (line) in
            var fields = line.componentsSeparatedByString(" ")
            let elementName = fields.removeFirst()
            let attributeDict = fields.map({ $0.componentsSeparatedByString("=") }).reduce([String: String]()) { acc, comps in
                var ret = acc
                ret[comps[0]] = comps[1].stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\""))
                return ret
            }

            parser(didStartElement: elementName, attributes: attributeDict)
        }
    }

    private func parser(didStartElement elementName: String, attributes attributeDict: [String : String]) {

        switch elementName {
        case "info":
            info = BitmapFontInfo(face: attributeDict["face"]!,
                                  size: CGFloatFromString(attributeDict["size"]!),
                                  bold: BoolFromString(attributeDict["bold"]!),
                                  italic: BoolFromString(attributeDict["italic"]!),
                                  charset: attributeDict["charset"]!,
                                  unicode: BoolFromString(attributeDict["unicode"]!),
                                  stretchH: CGFloatFromString(attributeDict["stretchH"]!),
                                  smooth: BoolFromString(attributeDict["smooth"]!),
                                  aa: IntFromString(attributeDict["aa"]!),
                                  padding: PaddingFromString(attributeDict["padding"]!),
                                  spacing: SpacingFromString(attributeDict["spacing"]!),
                                  outline: CGFloatFromString(attributeDict["outline"]!))
            break

        case "common":
            common = BitmapFontCommon(lineHeight: CGFloatFromString(attributeDict["lineHeight"]!),
                                      base: CGFloatFromString(attributeDict["base"]!),
                                      scaleW: CGFloatFromString(attributeDict["scaleW"]!),
                                      scaleH: CGFloatFromString(attributeDict["scaleH"]!),
                                      pages: IntFromString(attributeDict["pages"]!),
                                      packed: BoolFromString(attributeDict["packed"]!))
            break

        case "pages":
            pages = [BitmapFontPage]()
            break

        case "page":
            let id = IntFromString(attributeDict["id"]!)
            let fullPath = _directory + "/" + attributeDict["file"]!

            #if os(OSX)
                let image = NSImage(contentsOfFile: fullPath)
                var imageRect = CGRectMake(0, 0, image!.size.width, image!.size.height)
                let cgImage = image!.CGImageForProposedRect(&imageRect, context: nil, hints: nil)!
            #else
                let image = UIImage(contentsOfFile: fullPath)
                let cgImage = image!.CGImage!
            #endif

            let texture = SKTexture(CGImage: cgImage)

            pages?.append(BitmapFontPage(id: id, texture: texture))
            break

        case "chars":
            characters = [Character: BitmapFontCharacter]()
            break

        case "char":
            let id = IntFromString(attributeDict["id"]!)
            let idChar = Character(UnicodeScalar(id))

            characters![idChar] = BitmapFontCharacter(id: id,
                                                      x: CGFloatFromString(attributeDict["x"]!),
                                                      y: CGFloatFromString(attributeDict["y"]!),
                                                      width: CGFloatFromString(attributeDict["width"]!),
                                                      height: CGFloatFromString(attributeDict["height"]!),
                                                      xoffset: CGFloatFromString(attributeDict["xoffset"]!),
                                                      yoffset: CGFloatFromString(attributeDict["yoffset"]!),
                                                      xadvance: CGFloatFromString(attributeDict["xadvance"]!),
                                                      page: IntFromString(attributeDict["page"]!),
                                                      chnl: ColorChannelFromString(attributeDict["chnl"]!))
            break

        case "kernings":
            kernings = [Character: [BitmapFontKerning]]()
            break

        case "kerning":
            let first = IntFromString(attributeDict["first"]!)
            let firstChar = Character(UnicodeScalar(first))

            let second = IntFromString(attributeDict["second"]!)
            let secondChar = Character(UnicodeScalar(second))

            let amount = CGFloatFromString(attributeDict["amount"]!)

            if (kernings?[firstChar] == nil) {
                kernings?[firstChar] = [BitmapFontKerning(first: firstChar,
                    second: secondChar,
                    amount: amount)]
            } else {
                kernings?[firstChar]!.append(BitmapFontKerning(first: firstChar,
                    second: secondChar,
                    amount: amount))
            }
            break
            
        default: break
            
        }
    }
}