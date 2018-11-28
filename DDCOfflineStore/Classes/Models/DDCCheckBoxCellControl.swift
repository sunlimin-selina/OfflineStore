//
//  DDCCheckBoxTableViewCellControl.swift
//  DDCOfflineStore
//
//  Created by sunlimin on 2018/11/5.
//  Copyright © 2018 DayDayCook. All rights reserved.
//

import Foundation
import UIKit

@objc protocol DDCCheckBoxCellControlDelegate {
    @objc optional func cellControl(_ control: DDCCheckBoxCellControl, didFinishEdited count: Int, isFilled: Bool)
    
    @objc optional func cellControl(_ control: DDCCheckBoxCellControl, didSelectItemAt indexPath: IndexPath)

}

class DDCCheckBoxCellControl: NSObject {
    static let kCTag: Int = 200

    var delegate: DDCCheckBoxCellControlDelegate?
    var selectedItems: NSMutableArray = NSMutableArray()
    var selectedIndexes: NSMutableArray = NSMutableArray()
    var cell: DDCCheckBoxCollectionViewCell?
    var model: DDCCourseModel?
    var indexPath: IndexPath?

    var hasImage: Bool?
    
    func cellHeight() -> CGFloat {
        if self.model != nil && self.model!.attributes != nil{
            return CGFloat((self.model!.isSelected ? (self.model!.attributes?.count)! + 1: 1 ) * 42)
        }
        return 42
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
        self.indexPath = indexPath
        
        if let _attributes = model.attributes,
            (_attributes.count > 0 && model.isSelected) {
            self.cell!.buttonCount = _attributes.count
            for index in 0...(self.cell!.buttons.count - 1) {
                let view: DDCCheckBox = self.cell!.buttons[index]
                view.button.isEnabled = true
                view.button.tag = index + DDCCheckBoxCellControl.kCTag
                let subtitle:String = _attributes[index].attributeValue!
                view.button.setTitle(subtitle, for: .normal)
                view.button.isSelected = _attributes[index].isSelected
                view.textField.isHidden = !view.button.isSelected
                view.textField.textField.delegate = self
                view.textField.textField.tag = index + DDCCheckBoxCellControl.kCTag
                view.textField.textField.text = _attributes[index].totalCount != 0 ? "\(_attributes[index].totalCount)" : ""
                view.setHandler { (sender) in
                    self.buttonClicked(sender: sender)
                }
                view.updateLayoutConstraints(width: DDCString.width(string: subtitle, font: UIFont.systemFont(ofSize: 20.0), height: 40.0) + 45)
            }
        } else {
            self.cell!.checkBox.isUserInteractionEnabled = true
            self.cell!.checkBox.textField.textField.delegate = self
            self.cell!.checkBox.textField.isHidden = false//!model.isSelected
            self.cell!.checkBox.setHandler { (sender) in
                self.sectionButtonClicked(sender: sender)
            }
//            self.cell!.textField.isHidden = !model.isSelected
//            self.cell!.textField.textField.delegate = self
//            self.cell!.textField.textField.text = model.totalCount != 0 ? "\(model.totalCount)" : ""
        }
        let title = model.categoryName ?? model.courseName
        self.cell!.checkBox.button.setTitle(title, for: .normal)
//        self.cell!.updateConstraints(width: DDCString.width(string: title!, font: UIFont.systemFont(ofSize: 20.0), height: 30.0) + 50.0)
        self.cell!.checkBox.button.isSelected = model.isSelected
        self.cell!.subContentView.isHidden = !model.isSelected
    }
    
    func buttonClicked(sender: DDCCheckBox) {
        sender.button.isSelected = !sender.button.isSelected
        sender.textField.isHidden = !sender.button.isSelected
        self.delegate?.cellControl!(self, didFinishEdited: 0, isFilled: false)

        if (self.model?.attributes?.count)! <= 0 {
            return
        }
        let item: DDCCourseAttributeModel = (self.model?.attributes![sender.button.tag - DDCCheckBoxCellControl.kCTag])!
        item.isSelected = sender.button.isSelected

        if (sender.isSelected) {
            if self.selectedItems.contains(item) {
                self.selectedItems.add(item)
            }
        } else {
            if self.selectedItems.contains(item) {
                self.selectedItems.remove(item)
            }
        }
    }
    
    func sectionButtonClicked(sender: DDCCheckBox) {
        self.delegate?.cellControl!(self, didSelectItemAt: self.indexPath!)
    }
}

extension DDCCheckBoxCellControl: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //限制字符长度
        let existedLength: Int = (textField.text?.count)!
        let selectedLength: Int = range.length
        let replaceLength: Int = string.count
        let totalLength: Int = existedLength - selectedLength + replaceLength
        
        if (totalLength > 3) {//字符数量不超过3
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let _attributes = self.model!.attributes,
            (_attributes.count > 0 && self.model!.isSelected) {
            let item: DDCCourseAttributeModel = (self.model?.attributes![textField.tag - DDCCheckBoxCellControl.kCTag])!
            item.totalCount = Int(textField.text!)!
            if item.totalCount > 0 {
                let isFilled = self.isCompleted()
                self.delegate?.cellControl!(self, didFinishEdited: item.totalCount, isFilled: isFilled)
            }
        } else {
            self.model!.totalCount = Int(textField.text!)!
            if self.model!.totalCount > 0 {
                let isFilled = self.isCompleted()
                self.delegate?.cellControl!(self, didFinishEdited: self.model!.totalCount, isFilled: isFilled)
            }
        }
        
    }
    
    func isCompleted() -> Bool {
        var selectedCount: Int = 0
        var filledCount: Int = 0

        if self.model!.isSelected == true {
            if let _attributes = self.model!.attributes {
                for att in _attributes {
                    if att.isSelected == true {
                        selectedCount += 1
                    }
                    if att.totalCount > 0{
                        filledCount += 1
                    }
                }
            }
        }
        if selectedCount != filledCount {
            return false
        }
        return true
    }
}
