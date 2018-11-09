//
//  UIView+DDCToast.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/10.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {

    enum ImagePosition : UInt{
        case top
        case left
        case bottom
        case right
    }

    func makeDDCToast(message: String,image: UIImage,position: ImagePosition,finishedBlock:(()->Void)?) {
        //初始化
        let kVerticalPadding : CGFloat = 25.0
        let kSpacing : CGFloat  = 15.0
        let kViewWidth : CGFloat = 240.0
        let kLeftPadding : CGFloat = 15.0
        
        let backgroundView = UIView()
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 8.0
        backgroundView.backgroundColor = DDCColor.colorWithHex(RGB: 0x000000, alpha: 0.7)
        backgroundView.alpha = 0.0

        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16.0)
        
        let imageView = UIImageView.init(image: image)
        
        //添加子图
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(imageView)
        self.addSubview(backgroundView)
        
        //获取字体高度
        let titleHeight : CGFloat = self.addAttributeString(message: message, titleLabel: titleLabel)
        let height = kVerticalPadding * 2 + image.size.height + kSpacing + titleHeight
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            if DDCKeyboardStateListener.sharedStore().isVisible {
                make.centerY.equalTo(self).offset(-50.0)
            } else {
                make.centerY.equalTo(self)
            }
            make.width.equalTo(kViewWidth)
            make.height.equalTo(height)
        }
        
        switch position {
        case .top:
            do{
                imageView.snp.makeConstraints { (make) in
                    make.top.equalTo(backgroundView).offset(kVerticalPadding)
                    make.centerX.equalTo(backgroundView)
                    make.width.equalTo(image.size.width)
                    make.height.equalTo(image.size.height)
                }
                
                titleLabel.snp.makeConstraints { (make) in
                    make.bottom.equalTo(backgroundView).offset(-kVerticalPadding)
                    make.left.equalTo(backgroundView).offset(kLeftPadding)
                    make.right.equalTo(backgroundView).offset(-kLeftPadding)
                    make.height.equalTo(titleHeight)
                }
            }
        case .bottom:
            do {
                titleLabel.snp.makeConstraints { (make) in
                    make.top.equalTo(backgroundView).offset(kVerticalPadding)
                    make.left.equalTo(backgroundView).offset(kLeftPadding)
                    make.right.equalTo(backgroundView).offset(-kLeftPadding)
                    make.height.equalTo(titleHeight)
                }

                imageView.snp.makeConstraints { (make) in
                    make.bottom.equalTo(backgroundView).offset(-kVerticalPadding)
                    make.centerX.equalTo(backgroundView)
                    make.width.equalTo(image.size.width)
                    make.height.equalTo(image.size.height)
                }
            }
        default:
            break
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            backgroundView.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                backgroundView.alpha = 0.0
            }) { (finished) in
                backgroundView.removeFromSuperview()
                if finishedBlock != nil {
                    finishedBlock!()
                }
            }
        }
    }

    
    func addAttributeString(message: String, titleLabel:UILabel) -> CGFloat {
        let kViewWidth : CGFloat = 240.0
        let kLeftPadding : CGFloat = 15.0
        let attributeString : NSMutableAttributedString = NSMutableAttributedString.init(string: message)
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7.0     //设置行间距
        paragraphStyle.alignment = .center
        attributeString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributeString.length))
        attributeString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], range: NSMakeRange(0, attributeString.length))
        
        var titleHeight: CGFloat = attributeString.boundingRect(with: CGSize.init(width: kViewWidth - 2*kLeftPadding, height:CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size.height
        
        if (titleHeight<30)
        {
            titleHeight = 20.0
        }
        else
        {
            titleHeight = 20.0 * 2 + 7.0
        }
        
        titleLabel.attributedText = attributeString
        
        return titleHeight
    }
    
    func makeDDCToast(message: String, image: UIImage, position: ImagePosition) {
        self.makeDDCToast(message: message, image: image, position: position, finishedBlock: nil)
    }
    
    func makeDDCToast(message: String, image: UIImage) {
        self.makeDDCToast(message: message, image: image, position: .top, finishedBlock: nil)
    }
}
