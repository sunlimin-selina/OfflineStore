//
//  DDCContractStateInfoCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/10/16.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCContractStateInfoCell: UICollectionViewCell {
    let kIndicatorImgDiameter: CGFloat = 16.0
    let kIndicatorTopOffset: CGFloat = 5.0
    var line_left: UIButton?
    var line_right: UIButton?

    private lazy var dot: UIButton = {
        let _dot: UIButton = UIButton.init(type: .custom)
        _dot.backgroundColor = UIColor.white
        _dot.setImage(UIImage.init(named: "icon_state_node_done"), for: .normal)
        _dot.setImage(UIImage.init(named: "icon_state_node_doing"), for: .selected)
        _dot.setImage(UIImage.init(named: "icon_state_node_todo"), for: .disabled)
        _dot.layer.masksToBounds = true
        _dot.layer.cornerRadius = kIndicatorImgDiameter/2.0
        _dot.isUserInteractionEnabled = false
        return _dot
    }()
    
    private lazy var titleButton: UIButton = {
        let _titleButton: UIButton = UIButton.init(type: .custom)
        _titleButton.titleLabel!.numberOfLines = 0
        _titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        _titleButton.setTitleColor(DDCColor.mainColor.red, for: .normal)
        _titleButton.setTitleColor(DDCColor.mainColor.red, for: .selected)
        _titleButton.setTitleColor(DDCColor.fontColor.gray, for: .disabled)

        return _titleButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.dot)
        self.contentView.addSubview(self.titleButton)
        self.setupViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.dot.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(kIndicatorTopOffset)
            make.height.width.equalTo(32.0)
        })
        
        self.titleButton.snp.makeConstraints({ (make) in
            make.top.equalTo(dot.snp.bottomMargin).offset(10)
            make.centerX.equalTo(dot)
        })
    }
    
    func configureCell(model: DDCContractStateInfoViewModel) {
        self.titleButton.setTitle(model.title, for: .normal)
        self.dot.isSelected = (model.state == DDCContractState.doing)
        self.dot.isEnabled = (model.state != DDCContractState.todo)
    }
    
    class func size(data: DDCContractStateInfoViewModel) -> CGSize {
        var width: CGFloat = 0.0
        if let title = data.title {
            width = DDCString.width(string: title, font: UIFont.systemFont(ofSize: 16.0, weight: (data.state == DDCContractState.todo) ? UIFont.Weight.light:UIFont.Weight.regular), height: 20.0)
        }
        return CGSize.init(width: width, height: 60.0)
    }
}
