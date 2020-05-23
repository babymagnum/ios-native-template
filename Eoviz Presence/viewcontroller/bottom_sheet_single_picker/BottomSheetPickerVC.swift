//
//  BottomSheetSinglePickerVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

protocol BottomSheetPickerProtocol {
    func getItem(index: Int)
}

class BottomSheetPickerVC: BaseViewController, UIPickerViewDelegate {

    @IBOutlet weak var firstPickerView: UIPickerView!
    
    var useSingleArray: Bool! // determine type of picker
    var singleArray: [String]! // single dimension array
    var multiArray: [[String]]! // multi dimension array
    var delegate: BottomSheetPickerProtocol!
    var selectedValue: String?
    
    private var selectedIndex = 0
    @Inject private var filterRiwayatTukarShiftVM: FilterRiwayatTukarShiftVM
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _selectedValue = self.selectedValue {
            let index = self.singleArray.firstIndex(of: _selectedValue) ?? 0
            self.selectedIndex = index
            self.firstPickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    private func setupView() {
        firstPickerView.delegate = self
        firstPickerView.dataSource = self
    }

    @IBAction func buttonPilihClick(_ sender: Any) {
        delegate.getItem(index: selectedIndex)
        dismiss(animated: true, completion: nil)
    }
}

extension BottomSheetPickerVC: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return singleArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // change this to match with multi array
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return singleArray[row]
        // return pickerData[component][row] // uncomment this code for multi array
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (picker == firstPickerView) {
            // for multi array -> multiArray[component][row]
            // for single array -> singleArray[row]
            selectedIndex = row
        }
    }
}
