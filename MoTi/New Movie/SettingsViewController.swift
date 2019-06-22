//
//  SettingsViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 05.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit

protocol SettingsSaving {
    func saveDate(date: Date)
    func saveDescription(desc: String?)
}


class SettingsViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
    var vcTitle: String?
    var delegate: SettingsSaving?
    var descText: String?
    
    @IBOutlet weak var viewLbl: UINavigationItem!
    
    let movieDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let headTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Label"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let descTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Your movies description:"
        textView.textColor = UIColor.lightGray
        textView.textAlignment = .left
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 5
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        if let movieTitle = vcTitle {
            viewLbl.title = movieTitle
        }
        descTextView.delegate = self
        
        prepareLayout()
        if let descText = descText {
            descTextView.text = descText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func prepareLayout(){
        view.addSubview(headTextView)
        
        headTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        headTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        headTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        headTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if let movieTitle = vcTitle {
            if(movieTitle.elementsEqual("Date")){
                headTextView.text = "Set the date:"
                prepareDateLayout()
            }
            else if(movieTitle.elementsEqual("Description")){
                headTextView.text = "Description of the movie:"
                descTextView.becomeFirstResponder()
                prepareDescLayout()
            }
        }
        else {
            return
        }
        
    }
    
    private func prepareDateLayout(){
        view.addSubview(movieDatePicker)
        movieDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieDatePicker.topAnchor.constraint(equalTo: headTextView.bottomAnchor, constant: 0).isActive = true
        movieDatePicker.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        movieDatePicker.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
    }
    
    private func prepareDescLayout(){
        view.addSubview(descTextView)
        descTextView.topAnchor.constraint(equalTo: headTextView.bottomAnchor, constant: 8).isActive = true
        descTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        descTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        descTextView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = descText == nil ? nil : descText
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your movies description:"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descTextView.resignFirstResponder()
        return false
    }
    @IBAction func finishEditing(_ sender: UIBarButtonItem) {
        
        if let vcTitle = vcTitle {
            if vcTitle.elementsEqual("Date") {
                delegate?.saveDate(date: movieDatePicker.date)
            }
            if vcTitle.elementsEqual("Description") {
                delegate?.saveDescription(desc: descTextView.text.isEmpty ? nil : descTextView.text)
            }
        }
        dismiss(animated: true)
    }
    

}


