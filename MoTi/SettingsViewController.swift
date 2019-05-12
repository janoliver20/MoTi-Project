//
//  SettingsViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 05.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import UIKit



class SettingsViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate {
    
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
        
        viewLbl.title = settingsArray[myIndex]
        descTextView.delegate = self
        
        prepareLayout()
    }
    
    private func prepareLayout(){
        view.addSubview(headTextView)
        
        headTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        headTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        headTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        headTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        if(settingsArray[myIndex].elementsEqual("Date")){
            headTextView.text = "Set the date:"
            prepareDateLayout()
        }
        else if(settingsArray[myIndex].elementsEqual("Description")){
            headTextView.text = "Description of the movie:"
            descTextView.becomeFirstResponder()
            prepareDescLayout()
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
            textView.text = nil
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
    
//    func textViewDidChange(_ textView: UITextView) {
//        
//    }
    
    

}


