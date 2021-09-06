//
//  ViewController.swift
//  SampleApp
//
//  Created by Ho Kam Hung on 2/10/2019.
//  Copyright © 2019 Ho Kam Hung. All rights reserved.
//

import UIKit

enum Device: Int
{
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case iPhoneX
    case iPhoneXSMax
    case iPhoneXR
    case Unknown
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NetworkControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var BottomBarViewBottomConstraint: NSLayoutConstraint!
    
    var items: Array<SentenceDataObject> = Array<SentenceDataObject>()
    var networkController: NetworkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (Notification) in
//            <#code#>
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        guard let info = notification.userInfo else {return}
        guard let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {return}

        switch DeviceType(){
            case .iPhone6:
                    BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height - 16
            case .iPhone6Plus:
                    BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height - 16
            case .iPhoneX:
                    BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height - 50
            case .iPhoneXR:
                    BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height - 50
            case .iPhoneXSMax:
                BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height - 50
            case .iPhone5:
                BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height - 16
            case .Unknown:
                BottomBarViewBottomConstraint.constant = keyboardSize.cgRectValue.height;
        }
    }
    
    @objc func keyboardWillHide(notification: Notification)
    {
        BottomBarViewBottomConstraint.constant = 0;
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count > 0 ? items.count : 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (items.count > 0) {
        
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentenceItem", for: indexPath) as? SentenceTableViewCell else {
                return UITableViewCell()
            }
            let item: SentenceDataObject? = items[indexPath.row]
            if item != nil {
                cell.InputLabel.text = item?.inputString
                if item?.outputString != nil {
                    cell.ResultLabel.text = item?.outputString
                    cell.LoadingIndicator.isHidden = true
                    cell.LoadingIndicator.stopAnimating()
                } else {
                    cell.LoadingIndicator.isHidden = false
                    cell.LoadingIndicator.startAnimating()
                }
            }
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "NoRecordCell", for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items.count > 0 ? 75 : 44;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Create new item
        let newDataObject: SentenceDataObject = SentenceDataObject()
        newDataObject.inputString = textField.text;
        items.append(newDataObject);
        let itemIndex: Int? = items.firstIndex(of: newDataObject)
        
        // refresh Table
        if (itemIndex != nil)
        {
            tableView.reloadData()
            //tableView.reloadRows(at: [IndexPath(row: itemIndex!, section: 0)], with: UITableView.RowAnimation.fade)
        }
        
        // NetworkController
        networkController.delegate = self as NetworkControllerDelegate
        networkController.convertStringToHiragana(inputString: textField.text ?? #""# , index: itemIndex ?? 0);
        
        textField.text = ""
        
        return true;
    }
    
    func responseStringOfHiragana(_ hiraganaString: String, index: Int) {
        let dataObject: SentenceDataObject = items[index]
        dataObject.outputString = hiraganaString
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.fade)
        }
    }
    
    func DeviceType()-> Device{
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return Device.iPhone5
            case 1334:
                return Device.iPhone6
            case 1920, 2208:
                return Device.iPhone6Plus
            case 2436:
                return Device.iPhoneX
            case 2688:
                return Device.iPhoneXSMax
            case 1792:
                return Device.iPhoneXR
            default:
                return Device.Unknown
            }
        }
        return Device.Unknown
    }
}

