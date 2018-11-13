//
//  DDCCheckBoxTableViewCellControl.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

class DDCCheckBoxCellControl: NSObject {
    static let kTag: Int = 100
    static let kCTag: Int = 200

    var selectedItems: NSMutableArray = NSMutableArray()
    var selectedIndexes: NSMutableArray = NSMutableArray()
    var cell: DDCCheckBoxCollectionViewCell?
    var model: DDCCourseModel?
    
    var hasImage: Bool?
    
    func cellHeight() -> CGFloat {
        return CGFloat((self.model!.isSelected ? (self.model!.attributes?.count)! + 1 : 1 ) * 40)
    }
    
    override init() {
        super.init()
    }
    
    init(cell: DDCCheckBoxCollectionViewCell) {
        super.init()
        self.cell = cell
    }
    
    func configureCell(model: DDCCourseModel, indexPath: IndexPath) {
        self.model = model
        
        if (model.attributes!.count > 0 && model.isSelected) {
            self.cell!.buttonCount = (model.attributes?.count)!
            for index in 0...(self.cell!.buttons.count - 1) {
                let view: DDCCheckBox = self.cell!.buttons[index]
                view.button.isEnabled = true
                view.button.tag = index + DDCCheckBoxCellControl.kCTag
                view.button.setTitle(model.attributes![index].attributeValue, for: .normal)
                view.button.isSelected = false
                view.setHandler { (sender) in
                    self.buttonClicked(sender: sender)
                }
            }
        }
        self.cell!.checkBox.button.setTitle(model.categoryName, for: .normal)
        self.cell!.checkBox.button.isSelected = model.isSelected
        self.cell!.subContentView.isHidden = !model.isSelected
    }
    
    func buttonClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected

//        if (self.model?.attributes?.count)! <= 0 {
//            return
//        }
//        let item: DDCCourseAttributeModel = (self.model?.attributes![sender.tag - DDCCheckBoxTableViewCellControl.kTag])!
//
//        if (sender.isSelected) {
//            if self.selectedItems.contains(item) {
//                self.selectedItems.add(item)
//                self.selectedIndexes.add(sender.tag - DDCCheckBoxTableViewCellControl.kTag)
//            }
//        } else {
//            if self.selectedItems.contains(item) {
//                self.selectedItems.remove(item)
//                self.selectedIndexes.remove(sender.tag - DDCCheckBoxTableViewCellControl.kTag)
//            }
//        }
        
//        TextFieldButton *textFieldButton = (TextFieldButton *)self.cell.buttons.lastObject;
//        CampaignItemModel *textFieldItem = items[textFieldButton.tag - kTag];
//        if (button == self.cell.buttons.lastObject) {
//            if (textFieldButton.selected) {
//                textFieldButton.textField.hidden = NO;
//            }
//        }
//        if (![self.selectedItems containsObject:textFieldItem]) {
//            textFieldButton.textField.hidden = YES;
//        }
    }
    
    func setupViewConstraints() {
        let kPadding: CGFloat = 5.0
//        self.cell.button.snp.remakeConstraints({ (make) in
//            make.top.equalTo(self)
//            make.left.greaterThanOrEqualTo(self)
//            make.right.equalTo(self.textField.snp_leftMargin)
//            make.height.equalTo(30.0)
//        })
        
        //        self.textField.snp.makeConstraints({ (make) in
        //            make.width.equalTo(screen.width - DDCAppConfig.kLeftMargin * 2)
        //            make.left.equalTo(self.button)
        //            make.height.equalTo(30.0)
        //        })
    }
}
