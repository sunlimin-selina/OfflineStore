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
        return CGFloat((self.model!.isSelected ? (self.model!.attributes?.count)! + 1 : 1 ) * 42)
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
                let subtitle:String = model.attributes![index].attributeValue!
                view.button.setTitle(subtitle, for: .normal)
                view.button.isSelected = false
                view.setHandler { (sender) in
                    self.buttonClicked(sender: sender)
                }
                view.updateLayoutConstraints(width: DDCString.width(string: subtitle, font: UIFont.systemFont(ofSize: 20.0), height: 40.0) + 45)
            }
        }
        self.cell!.checkBox.button.setTitle(model.categoryName, for: .normal)
        self.cell!.checkBox.button.isSelected = model.isSelected
        self.cell!.subContentView.isHidden = !model.isSelected
    }
    
    func buttonClicked(sender: DDCCheckBox) {
        sender.button.isSelected = !sender.button.isSelected
        sender.textField.isHidden = !sender.button.isSelected
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
        
//        var textFieldButton: UIButton = self.cell!.buttons.lastObject
//
//        if (button == self.cell!.buttons.lastObject) {
//            if (textFieldButton.isSelected) {
//            }
//        }
////        if (![self.selectedItems containsObject:textFieldItem]) {
////            textFieldButton.textField.hidden = YES;
////        }
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

extension DDCCheckBoxCellControl: UITextFieldDelegate {
//    #pragma mark - UITextFieldDelegate
//    - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//    {
//    //限制字符长度
//    NSInteger existedLength = textField.text.length;
//    NSInteger selectedLength = range.length;
//    NSInteger replaceLength = string.length;
//    if (existedLength - selectedLength + replaceLength > 30) {
//    return NO;
//    }
//    self.content = textField.text;
//
//    return YES;
//    }
//
//    - (void)textFieldDidEndEditing:(UITextField *)textField
//    {
//    self.content = textField.text;
//    }
}
