//
//  MonthYearPicker.swift
//
//  Created by Ben Dodson on 15/04/2015.
//

import UIKit

class FilterPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let values = [2, 5]
    var value: Int = 0 {
        didSet {
            selectRow(value, inComponent: 0, animated: false)
        }
    }
    /*var value: Int = 0 {
        didSet {
            selectRow(value-1, inComponent: 0, animated: false)
        }
    }*/
    
    var onSelected: ((_ row: Int, _ ofValue: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }

    func commonSetup() {
        self.delegate = self
        self.dataSource = self
    }
    
    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(values[row])km"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let val = self.selectedRow(inComponent: 0)+1
        //self.value = val
        //let val = self.selectedRow(inComponent: 0)+1
        if let block = onSelected {
            block(row, values[row])
        }
        self.value = values[row]
    }
}
