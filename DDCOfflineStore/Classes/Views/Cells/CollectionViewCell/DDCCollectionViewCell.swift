//
//  DDCCollectionViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/12/14.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCCollectionViewCell: UICollectionViewCell {
    
    public lazy var labelButton: UIButton = {
        let _labelButton: UIButton = UIButton()
        _labelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        _labelButton.titleLabel?.textAlignment = .center
        _labelButton.isUserInteractionEnabled = false
        _labelButton.setTitleColor(DDCColor.fontColor.black, for: .normal)
        _labelButton.setTitleColor(DDCColor.mainColor.red, for: .selected)
        _labelButton.setBackgroundColor(DDCColor.complementaryColor.backgroundColor, for: .normal)
        _labelButton.setBackgroundColor(DDCColor.complementaryColor.lightRed, for: .selected)
        _labelButton.layer.cornerRadius = 20.0
        return _labelButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.labelButton)
        self.setupViewConstraints()
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        self.labelButton.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.contentView)
        })
    }
    
}
