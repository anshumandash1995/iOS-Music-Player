//
//  CardView.swift
//  Viper
//
//  Created by Anshuman Dash on 8/2/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerRadius:CGFloat = 2
    @IBInspectable var shadowOffsetWidth :CGFloat = 2
    @IBInspectable var shadowOffsetHeight:CGFloat = 2
    @IBInspectable var shadowColor:UIColor = .darkGray
    @IBInspectable var shadowOpacity:CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width:shadowOffsetWidth, height:shadowOffsetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
}
