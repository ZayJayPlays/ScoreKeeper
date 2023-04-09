//
//  PlayerDetailViewController.swift
//  Score Counter
//
//  Created by Zane Jones on 3/24/23.
//

import UIKit

class PlayerDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var player: PlayerScore

    @IBOutlet var playerNameTextField: UITextField!
    @IBOutlet var initialScoreTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    init?(coder: NSCoder, player: PlayerScore) {
        self.player = player
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.player = PlayerScore(name: "", image: nil, score: 0)
        super.init(coder: coder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    playerNameTextField.text = player.name
    initialScoreTextField.text = String(player.score ?? 0)
            if player.image != nil {
                imageView.image = UIImage(data: player.image!)

        
            title = "Edit Player"
        } else {
            title = "Add Player"
        }
        
    }
    
    func updateView() {
        if player.image != nil {
            imageView.image = UIImage(data: player.image!)
            
        }
        playerNameTextField.text = player.name
        initialScoreTextField.text = String(player.score ?? 0)
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default, handler: { (_) in imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true)
            })
            alertController.addAction(choosePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take a Photo", style: .default, handler: { (_) in imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            })
            alertController.addAction(takePhotoAction)
        }

        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        if let image = imageView.image, let text = playerNameTextField.text {
            let activityView = UIActivityViewController(activityItems: [image, text], applicationActivities: [])
            present(activityView, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.originalImage]! as! UIImage
        player.image = image.jpegData(compressionQuality: 0.9)
        dismiss(animated: true)
        updateView()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else {return}
        
        let image: Data? = imageView.image?.jpegData(compressionQuality: 0.9)
        let name: String? = playerNameTextField.text
        let score: Int? = Int(initialScoreTextField.text ?? "")
        
        player = PlayerScore(name: name ?? "", image: image, score: score ?? 0)
    }
    
}
