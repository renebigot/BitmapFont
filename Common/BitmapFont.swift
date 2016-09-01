//
//  BitmapFont.swift
//  BitmapFont
//
//  Created by René BIGOT on 20/07/2016.
//  Copyright © 2016 BRAE. All rights reserved.
//
// File description can be found at: http://www.angelcode.com/products/bmfont/doc/file_format.html

import Foundation
import SpriteKit

#if os(iOS)
    import UIKit
#endif

public class BitmapFont {
    var info: BitmapFontInfo?
    var common: BitmapFontCommon?
    var pages: [BitmapFontPage]?
    var kernings: [Character: [BitmapFontKerning]]?
    var characters: [Character: BitmapFontCharacter]?

    var bitmapFontScale: CGFloat = 1

    var _parser = XmlBitmapFontParser()

    init() {
        common = BitmapFontCommon(lineHeight: 0, base: 0, scaleW: 0, scaleH: 0, pages: 0, packed: false)
        info = BitmapFontInfo(face: "",
                              size: 0,
                              bold: false,
                              italic: false,
                              charset: "",
                              unicode: false,
                              stretchH: 0,
                              smooth: false,
                              aa: 0,
                              padding: Padding(top: 0, bottom: 0, left: 0, right: 0),
                              spacing: Spacing(horizontal: 0, vertical: 0),
                              outline: 0)
        pages = []
        kernings = [:]
        characters = [:]
    }

    public convenience init(withXMLFileAt filePath: String, fontSize: CGFloat) {
        self.init()

        parseXml(at: filePath)
        parseInfo(fontSize)

        parseCommon()
        parsePages()
        parseKernings()
        parseCharacters()
    }

    public func nodeForText(text: String) -> SKSpriteNode {
        return nodeForText(text, alignment: .Left)
    }

    public func nodeForText(text: String, alignment: NSTextAlignment) -> SKSpriteNode {
        return nodeForText(text, alignment: alignment, boundingRect: CGRectZero)
    }

    public func nodeForText(text: String, alignment align: NSTextAlignment, boundingRect rect: CGRect) -> SKSpriteNode {
        var alignment = align
        var boundingRect = rect
        var newText = ""

        if (alignment != .Left && alignment != .Right && alignment != .Center && alignment != .Justified) {
            alignment = .Left
        }

        let rawLines = linesForText(text)
        var lines = [String]()

        if (boundingRect != CGRectZero) {
            rawLines.forEach { (rawLine) in
                var totalLineWidth: CGFloat = 0
                var line = ""
                var space = ""
                let words = rawLine.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " "))

                words.forEach({ (word) in
                    let wordSize = sizeForText(space + word)
                    if (totalLineWidth + wordSize.width <= boundingRect.size.width) {
                        line += space + word
                        totalLineWidth += wordSize.width
                        space = " "
                    } else if (CGFloat(lines.count + 1) * common!.lineHeight <= boundingRect.size.height) {
                        lines.append(line)
                        newText += line + "\n"
                        line = word
                        totalLineWidth = wordSize.width
                        space = " "
                    }
                })

                if (CGFloat(lines.count + 1) * common!.lineHeight <= boundingRect.size.height) {
                    lines.append(line + "\n")
                }
            }
        } else {
            newText = text
            lines = rawLines
            boundingRect = CGRect(origin: CGPointZero, size: sizeForText(newText))
        }

        newText = newText.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\n\r")) + "\n"

        let resultNode = SKSpriteNode()
        resultNode.size = CGSizeZero
        resultNode.anchorPoint = CGPoint(x: 0, y: 1)
        resultNode.position = boundingRect.origin

        var currentCharDestination = CGPointZero

        lines.forEach { (line) in
            var lastChar: Character?
            let lineSize = sizeForText(line)
            var justifiedCharOffset: CGFloat = 0

            switch (alignment) {
            case .Justified:
                if (line.characters.count > 1 && line.characters.last != "\n") {
                    justifiedCharOffset = (boundingRect.size.width - lineSize.width) / (CGFloat(line.characters.count) - 1)
                }

                break

            case .Center:
                currentCharDestination.x = (boundingRect.size.width - lineSize.width) / 2
                break

            case .Right:
                currentCharDestination.x = boundingRect.size.width - lineSize.width
                break

            default: break
            }

            line.characters.forEach { (character) in
                var newChar = character

                if (newChar == "\n") {
                    return
                }

                if (characters![character] == nil) {
                    newChar = " "
                }

                if (lastChar != nil) {
                    let characterKernings = kernings![lastChar!]

                    characterKernings?.forEach({ (kerning) in
                        if (kerning.first == lastChar && kerning.second == newChar) {
                            currentCharDestination.x += kerning.amount
                            return
                        }
                    })
                }
                
                let pageIndex = characters![newChar]?.page
                let texture = pages![pageIndex!].texture

                let origCharRect = CGRect(x: characters![newChar]!.x / texture.size().width,
                    y: 1 - (characters![newChar]!.y + characters![newChar]!.height) / texture.size().height,
                    width: characters![newChar]!.width / texture.size().width,
                    height: characters![newChar]!.height / texture.size().height)

                var destCharRect = CGRect(x: currentCharDestination.x,
                    y: currentCharDestination.y - characters![newChar]!.yoffset,
                    width: characters![newChar]!.width,
                    height: characters![newChar]!.height)

                if (lastChar != nil) {
                     destCharRect.origin.x += characters![newChar]!.xoffset
                } else {
                    currentCharDestination.x -= characters![newChar]!.xoffset
                }

                let charTexture = SKTexture(rect: origCharRect, inTexture: texture)

                let charNode = SKSpriteNode(texture: charTexture, size: destCharRect.size)
                charNode.anchorPoint = CGPoint(x: 0, y: 1)
                charNode.position = destCharRect.origin
                resultNode.addChild(charNode)

                currentCharDestination.x += characters![newChar]!.xadvance + justifiedCharOffset

                resultNode.size = CGSize(width: max(resultNode.size.width, charNode.size.width + charNode.position.x),
                    height: max(resultNode.size.height, charNode.size.height - charNode.position.y))

                lastChar = character
            }

            currentCharDestination.x = 0
            currentCharDestination.y -= common!.lineHeight
        }

        return resultNode
    }


    public func sizeForText(text: String) -> CGSize {
        let lines = linesForText(text)

        var retVal = CGSizeZero

        lines.forEach { (line) in
            var lastChar: Character?
            var lineWidth: CGFloat = 0

            line.characters.forEach { (character) in
                var newChar = character
                if (characters![character] == nil) {
                    newChar = " "
                }

                if (lastChar != nil) {
                    let characterKernings = kernings![lastChar!]

                    characterKernings?.forEach({ (kerning) in
                        if (kerning.first == lastChar && kerning.second == newChar) {
                            lineWidth += kerning.amount
                            return
                        }
                    })
                } else {
                    lineWidth -= characters![newChar]!.xoffset
                }

                lineWidth += characters![newChar]!.xadvance

                lastChar = character
            }

            retVal.width = max(lineWidth, retVal.width)
            retVal.height += common!.lineHeight
        }
        
        return retVal
    }

    public func parseXml(at filePath: String) {
        _parser = XmlBitmapFontParser(filePath: filePath)
    }

    func parseCommon() {
        common = BitmapFontCommon(lineHeight: _parser.common!.lineHeight * bitmapFontScale,
                                  base: _parser.common!.base * bitmapFontScale,
                                  scaleW: _parser.common!.scaleW * bitmapFontScale,
                                  scaleH: _parser.common!.scaleH * bitmapFontScale,
                                  pages: _parser.common!.pages,
                                  packed: _parser.common!.packed)

    }

    func parseInfo(fontSize: CGFloat) {
        let originalSize = _parser.info!.size
        bitmapFontScale = fontSize / originalSize

        info = _parser.info!
    }

    func parsePages() {
        pages = [BitmapFontPage]()

        let parserPages = _parser.pages
        parserPages?.forEach({ (page) in
            let texture = scaledTexture(page.texture)
            pages?.append(BitmapFontPage(id: page.id, texture: texture))
        })
    }

    func parseKernings() {
        kernings = [Character: [BitmapFontKerning]]()

        _parser.kernings?.keys.forEach({ (key) in
            let characterKernings = _parser.kernings![key]
            kernings![key] = [BitmapFontKerning]()

            characterKernings?.forEach({ (kerning) in
                kernings![key]?.append(BitmapFontKerning(first: kerning.first,
                    second: kerning.second,
                    amount: kerning.amount * bitmapFontScale))
            })
        })
    }

    func parseCharacters() {
        characters = [Character: BitmapFontCharacter]()

        _parser.characters?.keys.forEach({ (key) in
            let char = _parser.characters![key]
            characters![key] = BitmapFontCharacter(id: char!.id,
                x: char!.x * bitmapFontScale,
                y: char!.y * bitmapFontScale,
                width: char!.width * bitmapFontScale,
                height: char!.height * bitmapFontScale,
                xoffset: char!.xoffset * bitmapFontScale,
                yoffset: char!.yoffset * bitmapFontScale,
                xadvance: char!.xadvance * bitmapFontScale,
                page: char!.page,
                chnl: char!.chnl)
        })
    }
    
    private func scaledTexture(texture: SKTexture) -> SKTexture {
        let cgImage = texture.CGImage()

        let width = Int(CGFloat(CGImageGetWidth(cgImage)) * bitmapFontScale)
        let height = Int(CGFloat(CGImageGetHeight(cgImage)) * bitmapFontScale)
        let bitsPerComponent = CGImageGetBitsPerComponent(cgImage)
        let bytesPerRow = width * CGImageGetBytesPerRow(cgImage) / CGImageGetWidth(cgImage)
        let colorSpace = CGImageGetColorSpace(cgImage)
        let bitmapInfo = CGImageGetBitmapInfo(cgImage)

        let context = CGBitmapContextCreate(nil, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)

        CGContextSetInterpolationQuality(context, .High)

        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)), cgImage)

        return CGBitmapContextCreateImage(context).flatMap { SKTexture(CGImage: $0) }!
    }

    private func linesForText(text: String) -> [String] {
        return text.stringByReplacingOccurrencesOfString("\n\r", withString: "\n")
            .stringByReplacingOccurrencesOfString("\r\n", withString: "\n")
            .stringByReplacingOccurrencesOfString("\r", withString: "\n")
            .stringByReplacingOccurrencesOfString("\t", withString: "    ")
            .componentsSeparatedByString("\n")
    }
}

