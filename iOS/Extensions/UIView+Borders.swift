//
//  UIView+Borders.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/7/21.
//

import UIKit

extension UIView {
    func addDashedBorder(color: UIColor, cornerRadius: CGFloat = 5.0) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
