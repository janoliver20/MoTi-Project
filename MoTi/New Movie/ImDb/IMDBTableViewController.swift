//
//  IMDBTableViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 26.06.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import Foundation
import UIKit

class IMDBTableViewController: UIViewController {
    
    let urlString = "https://itunes.apple.com/search?term=Transporter&entity=movie"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoviesFromIMDB(with: urlString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadMoviesFromIMDB(with urlString: String) {
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            
//            print(response)

            if let data = data {
                do {
                    let serializeResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String:Any]
                    print(serializeResult)
                    let dataBase = try JSONDecoder().decode(DataBase.self, from: data)
                    print(dataBase.resultCount)
                } catch let dataError as NSError {
                    print(dataError)
                }
            }


        })

        dataTask.resume()
        
    }
    
    
}

