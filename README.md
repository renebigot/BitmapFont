# BitmapFont

BitmapFont will allow you to use bitmap font (Both XML or TXT file formats) easily and freely inside your SpriteKit game. (macOS, iOS, tvOS, watchOS)

## Installation

1. Drag **BitmapFont.xcodeproj** inside your Xcode projet.
2. Add **BitmapFont-*xxxOS***, where *xxxOS* is your target platform (macOS, iOS, tvOS, watchOS), in your target **Build Phases / Target dependencies**.
3. Add **BitmapFont.framework** in your target **Build Phases / Link Binary With Libraries**.
4. Compile.
5. Enjoy!

## Usage

A full working example could be found in Bitmap-Font-Example.xcodeproj.

* Add some font(s) in your project resources.
* In your code, get full path to your font file description (.fnt ou .txt):

        let fntFilePath = NSBundle(forClass: self.classForCoder).pathForResource("font", ofType: ".fnt", inDirectory: "XML-Font")!

* Create the font :

		//For XML BitmapFont
        let font = BitmapFont(withXmlFileAt:fntFilePath, fontSize: 100)
        
  or 

		//For TXT BitmapFont
		let font = BitmapFont(withTxtFileAt:fntFilePath, fontSize: 100)

  Use "fontSize:" to set your text size. The font images will be stretched if not set to native height!

* Create your text node (SKSpriteNode)

        // "Easy mode"
        let node1 = font.nodeForText("Super easy text node")
        
        // Alignment
        let node2 = font.nodeForText("Justified\nmulti lines text", alignment: .Justified)
        let node3 = font.nodeForText("Right aligned\nmulti lines text", alignment: .Right)
        let node4 = font.nodeForText("Centered\nmulti lines text", alignment: .Center)
        
        // Bounding box 
        // Node position : X=10 - Y=50 
        // Max dimension : W=1024 - H=250 
        let node5 = font.nodeForText("Centered\nmulti lines text", alignment: .Center, boundingRect: CGRect(x: 10, y: 10, width: 512, height: 250))

* Add node to SKScene

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

* Version 1.0 : First working version.

## Credits

Author: René BIGOT

## License

The XlsxReaderWriter library should be accompanied by a LICENSE file. This file contains the license relevant to this distribution. If no license exists, please contact me [@renebigot](https://twitter.com/renebigot).