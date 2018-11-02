//
//  DDCContractListTableViewCell.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/9/30.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import UIKit
import SnapKit

class DDCStatusViewModel: NSObject {
    var color : UIColor?
    var title : String?
    var imageName : String?

    init(color: UIColor, title: String, imageName: String) {
        self.color = color
        self.title = title
        self.imageName = imageName
    }

}

class DDCContractListTableViewCell: UITableViewCell {
    
    private lazy var icon : UIImageView = {
        let icon : UIImageView = UIImageView.init(image: UIImage.init(named: "icon_contractdetails_shengxiaozhong"))
        icon.contentMode = .scaleAspectFill
        icon.clipsToBounds = true
        return icon
    }()
    
    private lazy var titleLabel : UILabel = {
        let _titleLabel : UILabel = UILabel()
        _titleLabel.font = UIFont.systemFont(ofSize: 16)
        _titleLabel.textColor = DDCColor.fontColor.black
        return _titleLabel
    }()
    
    private lazy var contractSNLabel: UILabel = {
        let _contractSNLabel : UILabel = UILabel()
        _contractSNLabel.text = "KC-020021802-151722255251"
        _contractSNLabel.textColor = DDCColor.fontColor.gray
        _contractSNLabel.font = UIFont.systemFont(ofSize: 12)
        return _contractSNLabel
    }()
    
    private lazy var contractTypeButton: UIButton = {
        let _contractTypeButton: UIButton = UIButton()
        _contractTypeButton.setTitle("正式课", for: .normal)
        _contractTypeButton.setTitleColor(UIColor.black, for: .normal)
        _contractTypeButton.titleLabel?.font = UIFont.systemFont(ofSize: 6)
        _contractTypeButton.layer.borderColor = UIColor.gray.cgColor
        _contractTypeButton.layer.borderWidth = 1
        return _contractTypeButton
    }()
    
    private lazy var contractNameLabel: UILabel = {
        let _contractNameLabel: UILabel = UILabel()
        _contractNameLabel.text = "套餐名-规格名-29999"
        _contractNameLabel.textColor = DDCColor.fontColor.gray
        _contractNameLabel.font = UIFont.systemFont(ofSize: 12)
        return _contractNameLabel
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let _subtitleLabel : UILabel = UILabel()
        _subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        _subtitleLabel.textAlignment = .right
        return _subtitleLabel
    }()
    
    private lazy var datetime : UILabel = {
        let _datetime : UILabel = UILabel()
        _datetime.textColor = DDCColor.fontColor.gray
        _datetime.font = UIFont.systemFont(ofSize: 12)
        _datetime.textAlignment = .right
        return _datetime
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contractSNLabel)
        self.contentView.addSubview(self.contractTypeButton)
        self.contentView.addSubview(self.contractNameLabel)

        self.contentView.addSubview(self.subtitleLabel)
        self.contentView.addSubview(self.datetime)

        self.setupViewConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        let kLeftMargin: CGFloat = 20.0
        let kHeight: CGFloat = 30.0
        let kOffset: CGFloat = 5.0
        let kCenterOffset: CGFloat = 12.0

        self.icon.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(self)
            make.left.equalTo(kLeftMargin)
        })
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.icon.snp_rightMargin).offset(kLeftMargin)
            make.right.equalTo(self.subtitleLabel.snp_leftMargin)
            make.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contractSNLabel.snp_topMargin)
        })
        
        self.contractSNLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.titleLabel)
            make.centerY.equalTo(self.icon)
            make.height.equalTo(20)
        })
        
        self.contractTypeButton.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel)
            make.top.equalTo(self.contractSNLabel.snp_bottomMargin).offset(kOffset)
            make.height.equalTo(10.0)
            make.width.equalTo(40.0)
        })
        
        self.contractNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contractTypeButton.snp_rightMargin).offset(kOffset)
            make.right.equalTo(self.titleLabel)
            make.top.bottom.equalTo(self.contractTypeButton)
        })

        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.right.equalTo(self).offset(-kLeftMargin)
            make.centerY.equalTo(self.contentView).offset(-kCenterOffset)
            make.height.equalTo(kHeight)
        })
        
        self.datetime.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.subtitleLabel)
            make.centerY.equalTo(self.contentView).offset(kCenterOffset)
            make.height.equalTo(kHeight)
        })
        
    }
    
    func configureCell(model : DDCContractDetailsModel) {
        let title = "\(model.user!.nickName ?? "") \(model.user!.userName ?? "")"
        self.titleLabel.text = title
        self.datetime.text = model.info!.createDateString
        
        let status : DDCStatusViewModel = DDCContract.statusPairings[(model.showStatus?.rawValue)!]!
        self.subtitleLabel.text = status.title
        self.subtitleLabel.textColor = status.color
        self.icon.image = UIImage.init(named: status.imageName!)
    }
    
}
