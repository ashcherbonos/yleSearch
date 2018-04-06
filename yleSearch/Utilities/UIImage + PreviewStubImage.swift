//
//  PreviewStubImageView.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/3/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

public extension UIImage {
    public convenience init?(withStubLabel label: String) {
        
        // MARK: - utilities
        
        func randomIntFromZero(toExclusive maxrange: Int) -> Int {
            return Int(arc4random_uniform(UInt32(maxrange)))
        }
        
        var randomColor: UIColor {
            switch randomIntFromZero(toExclusive: 6) {
            case 0:
                return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            case 1:
                return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            case 2:
                return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            case 3:
                return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            case 4:
                return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            default:
                return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
        }
        
        let side = AppConstants.previewImageFullSize
        let diameter = AppConstants.previewImageDiameter
        let border = AppConstants.previewImageWhiteBorder
        let fullRect = CGRect(origin: .zero, size: CGSize(width: side, height: side))
        let rectOverCircle = CGRect(origin: CGPoint(x: border, y: border), size: CGSize(width: diameter, height: diameter))

        func drowCircle() {
            let circle = UIBezierPath(ovalIn: rectOverCircle)
            randomColor.setFill()
            circle.fill()
        }
        
        var attributes:[NSAttributedStringKey: Any] {
            let font = UIFont.preferredFont(forTextStyle: .body).withSize(rectOverCircle.height*0.8)
            let paragrafSyle = NSMutableParagraphStyle()
            paragrafSyle.alignment = .center
            return [.paragraphStyle:paragrafSyle, .font:font, .foregroundColor:UIColor.white]
        }
        
        func drowFirstCharOfTitle() {
            let stringToDraw = String((label.first) ?? "Y") as NSString
            stringToDraw.draw(in: rectOverCircle, withAttributes: attributes)
        }
        
        // MARK: - ImageContext
        
        UIGraphicsBeginImageContextWithOptions(fullRect.size, false, 0.0)
        drowCircle()
        drowFirstCharOfTitle()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
