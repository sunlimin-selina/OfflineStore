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
    let kIndicatorImgDiameter : CGFloat = 16.0
    let kIndicatorTopOffset : CGFloat = 5.0
    var line_left : UIButton?
    var line_right : UIButton?

    private lazy var dot : UIButton = {
        let _dot : UIButton = UIButton.init(type: .custom)
        _dot.backgroundColor = UIColor.red
        _dot.setImage(UIImage.init(named: "icon_state_node_done"), for: .normal)
        _dot.setImage(UIImage.init(named: "icon_state_node_doing"), for: .selected)
        _dot.setImage(UIImage.init(named: "icon_state_node_todo"), for: .disabled)
        _dot.layer.masksToBounds = true
        _dot.layer.cornerRadius = kIndicatorImgDiameter/2.0
        _dot.isUserInteractionEnabled = false
        return _dot
    }()
    
    private lazy var titleButton : UIButton = {
        let _titleButton : UIButton = UIButton.init(type: .custom)
        _titleButton.titleLabel!.numberOfLines = 0
        _titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return _titleButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
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
        })
        
        self.dot.snp.makeConstraints({ (make) in
            make.top.equalTo(dot.snp.bottomMargin).offset(10)
            make.centerX.equalTo(dot)
        })
    }
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        
//        self.contentView.layer.zPosition = 2;
//        
//        dot = [UIButton buttonWithType:UIButtonTypeCustom];
//        [dot setBackgroundColor: [UIColor whiteColor]];
//        [dot setImage:[UIImage imageNamed:@"icon_state_node_done"] forState:UIControlStateNormal];
//        [dot setImage:[UIImage imageNamed:@"icon_state_node_doing"] forState:UIControlStateSelected];
//        [dot setImage:[UIImage imageNamed:@"icon_state_node_todo"] forState:UIControlStateDisabled];
//        [self.contentView addSubview:dot];
//        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView);
//            make.top.equalTo(self.contentView).with.offset(kIndicatorTopOffset);
//            }];
//        dot.layer.masksToBounds = YES;
//        dot.layer.cornerRadius = kIndicatorImgDiameter/2.0f;
//        dot.userInteractionEnabled = NO;
//        
//        titleBtn = [DDCButton buttonWithType:UIButtonTypeCustom];
//        titleBtn.titleLabel.numberOfLines = 0;
//        [titleBtn setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular] forState:UIControlStateNormal];
//        [titleBtn setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular] forState:UIControlStateSelected];
//        [titleBtn setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightLight] forState:UIControlStateDisabled];
//        [titleBtn setTitleColor:COLOR_MAINORANGE forState:UIControlStateNormal];
//        [titleBtn setTitleColor:COLOR_MAINORANGE forState:UIControlStateSelected];
//        [titleBtn setTitleColor:COLOR_A5A4A4 forState:UIControlStateDisabled];
//        [self.contentView addSubview:titleBtn];
//        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(dot.mas_bottom).with.offset(10);
//            make.centerX.equalTo(dot);
//            }];
//        
//    }
//    return self;
//    }
//    
//    - (void)configureCellWithData:(ContractStateInfoViewModel *)data
//{
//    [titleBtn setTitle:data.title forState:UIControlStateNormal];
//    
//    dot.selected = data.state == ContractStateDoing;
//    dot.enabled = data.state != ContractStateTodo;
//    }
//    
//    + (CGFloat)yOffsetForConnectingLine
//        {
//            return kIndicatorTopOffset + kIndicatorImgDiameter/2;
//        }
//        
//        + (CGFloat)height
//            {
//                return 60.0f;
//            }
//            
//            + (CGSize)sizeWithData:(ContractStateInfoViewModel *)data
//{
//    CGFloat w = [data.title widthWithFont:[UIFont systemFontOfSize:16.0f weight:data.state == ContractStateTodo?UIFontWeightLight:UIFontWeightRegular] constrainedToHeight:20.0f];
//    return CGSizeMake(w, [self height]);
//}
