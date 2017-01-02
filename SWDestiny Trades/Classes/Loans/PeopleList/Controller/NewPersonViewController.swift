//
//  NewPersonViewController.swift
//  SWDestiny Trades
//
//  Created by Diogo Autilio on 27/12/16.
//  Copyright © 2016 Diogo Autilio. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class NewPersonViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    var delegate: PeopleListViewDelegate?
    let person = PersonDTO()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        CardsAPIClient.retrieveCard(successBlock: { (card: CardDTO) in

            self.person.name = card.name
            self.person.lastName = card.setName
            self.person.lentMe.append(card)
            self.person.borrowed.append(card)
        }) { (error: DataResponse<Any>) in
            print(error)
        }
    }

    // MARK: IBActions

    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonTouched(_ sender: Any) {
        //if !firstNameTextField.text!.isEmpty {
            delegate?.insertNew(person: person)
        //}
        dismiss(animated: true, completion: nil)
    }
}
