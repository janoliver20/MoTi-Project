//
//  NewMovieViewController.swift
//  MoTi
//
//  Created by Jan Cortiel on 19.05.19.
//  Copyright © 2019 Cortiel_Lehner. All rights reserved.
//

import CoreData
import UIKit

//var settingsArray = ["Date", "Friends", "Description", "Photo"]
var settingsArray = ["Date", "Description"]

struct PropertyKey {
    static let title = "title"
    static let desc = "movieDescription"
    static let date = "date"
    static let hasBeenWatched = "hasBeenWatched"
}

class NewMovieViewController: UIViewController, UITextFieldDelegate, SettingsSaving {
    
    @IBOutlet var movieTitle: UITextField!
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var watchedSegmentControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var specialPhoto: UIImageView!
    
    var imagePicker: UIImagePickerController!
    var descriptionText: String?
    var dateToWatch: Date?

    enum ImageSource {
        case photoLibrary
        case camera
    }

    var newPhoto: UIImage?
    var hasBeenWatched = false
    var myStringTitle = ""

    let ownPhoto: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.delegate = self
        tableView.tableFooterView = UIView()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        movieImage.isUserInteractionEnabled = true
        movieImage.addGestureRecognizer(tapGestureRecognizer)
        specialPhoto.isHidden = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        if specialPhoto.image == nil {
            specialPhoto.isHidden = true
        }
        else {
            specialPhoto.isHidden = false
        }

        loadSamplePhoto()
    }

    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        if let newImage = getNewImage() {
            movieImage.image = newImage
        }
    }

    private func loadSamplePhoto() {
        let samplePhoto = UIImage(named: "sampleImage1")
        movieImage.image = samplePhoto
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func saveDate(date: Date) {
        dateToWatch = date
        tableView.reloadData()
    }
    
    func saveDescription(desc: String?) {
        descriptionText = desc
        tableView.reloadData()
    }

    @IBAction func saveNewMovie(_ sender: UIBarButtonItem) {
        guard let movieTitle = movieTitle.text else {
            return
        }
        if movieTitle.isEmpty {
            let alert = UIAlertController(title: "No movie title entered!", message: "You need to enter a title!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        switch watchedSegmentControl.selectedSegmentIndex {
        case 0:
            hasBeenWatched = false
        case 1:
            hasBeenWatched = true
        default:
            break
        }

        if !MovieClass.allMovies.saveNewMovie(title: movieTitle, description: descriptionText ?? "", date: dateToWatch ?? Date(), hasBeenWatched: hasBeenWatched) {
            let alert = UIAlertController(title: "Movie was not saved!", message: "Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }

        NotificationCenter.default.post(name: .refreshTable, object: nil)

        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelNewMovie(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCustomPhoto(_ sender: UIButton) {
    }
    

    
}

extension NewMovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)

        cell.textLabel?.text = settingsArray[indexPath.row]
        
        if settingsArray[indexPath.row].elementsEqual("Date") {
            var dateToShow: String = ""
            if let dateToWatch = dateToWatch {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                dateToShow = formatter.string(from: dateToWatch)
            }
            
            cell.detailTextLabel?.text = dateToWatch == nil ? "Date" : dateToShow
        }
        
        if settingsArray[indexPath.row].elementsEqual("Description") {
            cell.detailTextLabel?.text = descriptionText == nil ? "Not Set" : "Set"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSetting = settingsArray[indexPath.row]
        myStringTitle = selectedSetting
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.vcTitle = myStringTitle
            destinationVC.delegate = self
            destinationVC.descText = descriptionText == nil ? "" : descriptionText
        }
    }
}

extension NewMovieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func getNewImage() -> UIImage? {
        var newImage: UIImage?
        choosePhotoMode()
        if let newPhoto = newPhoto {
            newImage = newPhoto
            self.newPhoto = nil
        }

        return newImage
    }

    func choosePhotoMode() {
        let optionMenu = UIAlertController(title: nil, message: "Choose a title image!", preferredStyle: .actionSheet)

        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default, handler: { (_: UIAlertAction!) -> Void in self.photoLibrary() })

        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { (_: UIAlertAction!) -> Void in self.camera() })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        optionMenu.addAction(choosePhoto)
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(cancelAction)

        present(optionMenu, animated: true, completion: nil)
    }

    func camera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }

    func photoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else {
            return
        }
        selectImageFrom(.photoLibrary)
    }

    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newPhoto = image
        } else {
            print("Something went wrong")
        }
        dismiss(animated: true, completion: nil)
    }

    func addImageView() {
        view.addSubview(ownPhoto)
    }
}
