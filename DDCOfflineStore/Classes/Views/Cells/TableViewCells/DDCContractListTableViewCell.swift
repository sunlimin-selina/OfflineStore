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
        _titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        _titleLabel.textColor = DDCColor.fontColor.thickBlack
        return _titleLabel
    }()
    
    private lazy var contractSNLabel: UILabel = {
        let _contractSNLabel : UILabel = UILabel()
        _contractSNLabel.text = "KC-020021802-151722255251"
        _contractSNLabel.textColor = DDCColor.fontColor.lightGray
        _contractSNLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return _contractSNLabel
    }()
    
    private lazy var contractTypeImage: UIImageView = {
        let _contractTypeImage: UIImageView = UIImageView()
        _contractTypeImage.image = UIImage.init(named: "Tab_homepage_tiyanke") // Tab_homepage_zhengshike
        _contractTypeImage.contentMode = .scaleAspectFit
        return _contractTypeImage
    }()
    
    private lazy var contractNameLabel: UILabel = {
        let _contractNameLabel: UILabel = UILabel()
        _contractNameLabel.text = "套餐名-规格名-29999"
        _contractNameLabel.textColor = DDCColor.fontColor.lightGray
        _contractNameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return _contractNameLabel
    }()
    
    private lazy var subtitleLabel : UILabel = {
        let _subtitleLabel : UILabel = UILabel()
        _subtitleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        _subtitleLabel.textAlignment = .right
        return _subtitleLabel
    }()
    
    private lazy var datetime : UILabel = {
        let _datetime : UILabel = UILabel()
        _datetime.textColor = DDCColor.fontColor.gray
        _datetime.font = UIFont.systemFont(ofSize: 16)
        _datetime.textAlignment = .right
        return _datetime
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contractSNLabel)
        self.contentView.addSubview(self.contractTypeImage)
        self.contentView.addSubview(self.contractNameLabel)
        self.contentView.addSubview(self.subtitleLabel)
        self.contentView.addSubview(self.datetime)
        self.setupViewConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewConstraints() {
        let kMargin: CGFloat = 20.0
        let kHeight: CGFloat = 30.0
        let kLabelHeight: CGFloat = 20.0
        let kOffset: CGFloat = 16.0
        let kLeftPadding: CGFloat = 10.0
        let kCenterOffset: CGFloat = 14.0
        self.icon.snp.makeConstraints({ (make) in
            make.width.height.equalTo(40)
            make.centerY.equalTo(self)
            make.left.equalTo(kMargin)
        })
        
        self.titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.icon.snp_rightMargin).offset(kMargin)
            make.right.equalTo(self.subtitleLabel.snp_leftMargin)
            make.top.equalTo(self.contentView).offset(kMargin)
            make.height.equalTo(kLabelHeight)
        })
        
        self.contractSNLabel.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self.titleLabel)
            make.centerY.equalTo(self.icon)
            make.height.equalTo(kLabelHeight)
        })
        
        self.contractTypeImage.snp.makeConstraints({ (make) in
            make.left.equalTo(self.titleLabel).offset(-2)
            make.top.equalTo(self.contractSNLabel.snp_bottomMargin).offset(kOffset)
            make.height.equalTo(18.0)
            make.width.equalTo(45.0)
        })
        
        self.contractNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(self.contractTypeImage.snp_rightMargin).offset(kLeftPadding)
            make.right.equalTo(self.titleLabel)
            make.centerY.equalTo(self.contractTypeImage)
            make.height.equalTo(kLabelHeight)
        })
        
        self.subtitleLabel.snp.makeConstraints({ (make) in
            make.width.equalTo(100)
            make.right.equalTo(self).offset(-kMargin)
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
