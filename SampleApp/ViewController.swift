//
//  ViewController.swift
//  SampleApp
//
//  Created by Ho Kam Hung on 2/10/2019.
//  Copyright © 2019 Ho Kam Hung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, NetworkControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputField: UITextField!
    
    var items: Array<SentenceDataObject> = Array<SentenceDataObject>()
    var networkController: NetworkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SentenceItem", for: indexPath) as? SentenceTableViewCell else {
            return UITableViewCell()
        }
//        cell.foodImage.image = UIImage(named: food[indexPath.row].image)
//        cell.foodNameLabel.text = food[indexPath.row].name
//        cell.addressLabel.text = food[indexPath.row].address
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75;
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
        var dataObject: SentenceDataObject = items[index]
        dataObject.outputString = hiraganaString
        
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.fade)
        }
    }
}

