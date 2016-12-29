//
//  NewLoanViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class NewLoanViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var delegate: LoansListViewDelegate?
    let person = PersonDTO()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        CardsAPIClient.retrieveCard(successBlock: { (card: CardDTO) in
            
            self.person.name = "panda"
            self.person.lastName = "lele"
            
            let ds = LoanDTO()
            ds.hasLentMe = true
            ds.card = card
            self.person.loans.append(ds)
        }) { (error: DataResponse<Any>) in
            print(error)
        }
        
    }

    // MARK: IBActions

    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonTouched(_ sender: Any) {
        if !firstNameTextField.text!.isEmpty {
            delegate?.insertNew(person: person)
        }
        dismiss(animated: true, completion: nil)
    }
}
