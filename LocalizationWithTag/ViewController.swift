//
//  ViewController.swift
//  LocalizationWithTag
//
//  Created by Afriyandi Setiawan on 4/1/17.
//  Copyright © 2017 Afriyandi Setiawan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lblHello.text = "hello_name".localized()
        if lblHello.font.isSupportBolt {
            let titleAttrs:Dictionary<String,AnyObject> = [NSFontAttributeName: lblHello.font.bold(),
                              NSForegroundColorAttributeName: UIColor.black]
            let g = convertTagFor(inputText: NSMutableAttributedString(string: String(format: "hello_name".localized(), "Jane")), withAttribute: titleAttrs, startWith: "<b>", endWith: "</b>")
            lblHello.attributedText = g
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertTagFor(inputText text: NSMutableAttributedString, withAttribute attribute: Dictionary<String, AnyObject>, startWith start: String, endWith end: String) -> NSMutableAttributedString {
        
        while let str1 = text.string.range(of: start), let str2 = text.string.range(of: end) {
            let hStart = text.string.distance(from: text.string.startIndex, to: str1.lowerBound)
            let hEnd = text.string.distance(from: text.string.index(text.string.startIndex, offsetBy: hStart), to: str1.upperBound)
            let tStart = text.string.distance(from: text.string.startIndex, to: str2.lowerBound)
            let tEnd = text.string.distance(from: text.string.index(text.string.startIndex, offsetBy: tStart), to: str2.upperBound)
            let x = NSMakeRange(hStart + hEnd, tStart - hStart - hEnd)
            let t = NSMakeRange(tStart, tEnd)
            let h = NSMakeRange(hStart, hEnd)
            text.addAttributes(attribute, range: x)
            text.replaceCharacters(in: t, with: "")
            text.replaceCharacters(in: h, with: "")
        }

        return text
    }
    
}


extension String {

    func localized(_ comment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }

}

extension UIFont {
    
    var isSupportBolt:Bool {
        get {
            if self.fontDescriptor.withSymbolicTraits(.traitBold) != nil {
                return true
            }
            return false
        }
    }
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
}
