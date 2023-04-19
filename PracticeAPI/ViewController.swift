//
//  ViewController.swift
//  PracticeAPI
//
//  Created by Lalaiya Sahil on 15/02/23.
//

import UIKit
import Alamofire
import FMDB

class ViewController: UIViewController {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    var arrOfUser: [UserDetails] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        for i in arrOfUser{
            let query = "INSERT INTO user values ('\(i.id)', '\(i.name)', '\(i.email)', '\(i.gender)', '\(i.status)');"
            
            let databaseObject = FMDatabase(path: AppDelegate.databasePath)
            if databaseObject.open(){
                let result = databaseObject.executeUpdate(query, withArgumentsIn: [])
                if result == true{
                    messageLabel.text = "Data Saved"
                }else{
                    messageLabel.text = "Data Not Saved"
                }
            }
        }
       
    }
    private func getUser(){
       
        AF.request("https://gorest.co.in/public/v2/users", method: .get).response { [self] response in
            debugPrint("response \(response)")
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    self.arrOfUser = try JSONDecoder().decode([UserDetails].self, from: apiData)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }

}
struct UserDetails: Decodable{
    var id: Double
    var name: String
    var email: String
    var gender: String
    var status: String
    }



