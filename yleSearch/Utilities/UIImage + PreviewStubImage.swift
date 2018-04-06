//
//  PreviewStubImageView.swift
//  yleSearch
//
//  Created by Oleksandr Shcherbonos on 4/3/18.
//  Copyright © 2018 Oleksandr Shcherbonos. All rights reserved.
//

import UIKit

public extension UIImage {
    
    // MARK: - convenience init
    
    public convenience init?(size: CGSize, withCircleDiametr diameter: CGFloat,  stubChar: Character?) {
        let fullRect = CGRect(origin: .zero, size: size)
        let xShift = (size.width - diameter) / 2
        let yShift = (size.height - diameter) / 2
        let rectOverCircle = CGRect(origin: CGPoint(x: xShift, y: yShift), size: CGSize(width: diameter, height: diameter))
        let char = stubChar ?? "A"
        
        UIGraphicsBeginImageContextWithOptions(fullRect.size, false, 0.0)
        UIImage.drowCircle(in: rectOverCircle, color: UIImage.color(for: char))
        UIImage.drowChar(char, in: rectOverCircle)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    // MARK: - utilities
    
    fileprivate static func color(for char: Character) -> UIColor {
        let amountOfCases = 6
        switch char.hashValue % amountOfCases {
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
    
    fileprivate static func drowCircle(in rect: CGRect, color: UIColor) {
        let circle = UIBezierPath(ovalIn: rect)
        color.setFill()
        circle.fill()
    }
    
    fileprivate static func stringAttributes(size: CGFloat) -> [NSAttributedStringKey: Any] {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(size)
        let paragrafSyle = NSMutableParagraphStyle()
        paragrafSyle.alignment = .center
        return [.paragraphStyle:paragrafSyle, .font:font, .foregroundColor:UIColor.white]
    }
    
    fileprivate static func drowChar(_ stubChar: Character, in rect: CGRect) {
        let stringToDraw = String(stubChar) as NSString
        stringToDraw.draw(in: rect, withAttributes: stringAttributes(size: rect.height*0.8))
    }
}
