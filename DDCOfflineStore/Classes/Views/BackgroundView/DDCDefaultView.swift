//
//  DDCDefaultView.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/8.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCDefaultView: UIView {
    
    static let instance: DDCDefaultView = DDCDefaultView(frame: CGRect.zero)
    class func sharedView() -> DDCDefaultView {
        return instance
    }
    
    lazy var contentView: UIView = {
        var _contentView = UIView()
        return _contentView
    }()
    
    lazy var imageView: UIImageView = {
        var _imageView = UIImageView.init(frame: CGRect.zero)
        _imageView.backgroundColor = UIColor.white
        _imageView.contentMode = .scaleAspectFit
        _imageView.clipsToBounds = true
        return _imageView
    }()
    
    lazy var titleLabel: UILabel = {
       var _titleLabel = UILabel.init(frame: CGRect.zero)
        _titleLabel.textColor = DDCColor.fontColor.gray
        _titleLabel.textAlignment = .center
        return _titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(title: String, image: UIImage, font: UIFont) {
        self.titleLabel.text = title
        self.titleLabel.font = font
        self.imageView.image = image
    }
    
    func setupViewConstraints() {
        self.contentView.snp.makeConstraints { (make) in
            make.width.centerX.centerY.equalTo(self)
            make.height.equalTo(250)
        }
        
        self.imageView.snp.makeConstraints { (make) in
            make.top.centerX.equalTo(self.contentView)
            make.bottom.equalTo(self.titleLabel.snp_topMargin)
            make.height.width.equalTo(200)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp_bottomMargin)
            make.width.equalTo(self.contentView)
            make.bottom.centerX.equalTo(self.contentView)
        }
    }
    
    func showDefaultView(view: UIView, title: String, image: UIImage){
        let defaultView = DDCDefaultView.sharedView()
        defaultView.setValue(title: title, image: image, font: UIFont.systemFont(ofSize: 16.0, weight: .light))
        if defaultView.constraints.count > 0{
            defaultView.removeFromSuperview()
        }
        view.addSubview(defaultView)
        defaultView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func showPromptView(view: UIView, title: String, image: UIImage, topPadding: CGFloat){
        let promptView = DDCDefaultView.sharedView()
        promptView.setValue(title: title, image: image, font: UIFont.systemFont(ofSize: 24.0, weight: .medium))
        promptView.titleLabel.textColor = DDCColor.fontColor.black
        promptView.titleLabel.numberOfLines = 0

        if promptView.constraints.count > 0{
            promptView.removeFromSuperview()
        }
        view.addSubview(promptView)
        promptView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(-topPadding)
            make.left.right.bottom.equalTo(view)
        }
        
    }
    
    
    func clear() {
        DDCDefaultView.sharedView().removeFromSuperview()
    }
}
