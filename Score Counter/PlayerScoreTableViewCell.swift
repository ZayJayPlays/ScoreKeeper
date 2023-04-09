//
//  PlayerScoreTableViewCell.swift
//  Score Counter
//
//  Created by Zane Jones on 3/23/23.
//

import UIKit

class PlayerScoreTableViewCell: UITableViewCell {

    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var scoreLabel: UILabel!
    
    
    var playerScore: PlayerScore? {
        didSet {
            updateView()
        }
    }
    var scoreChanged: ((_ value: Int) -> Void)?
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        scoreChanged?(Int(stepper.value))
    }
    
    func updateView() {
        guard let playerScore else {return}
        playerNameLabel.text = playerScore.name
        stepper.value = Double(playerScore.score ?? 0)
        scoreLabel.text = String(Int(stepper.value))
        if playerScore.image != nil {
            playerImage.image = UIImage(data: playerScore.image!)
        }
    }
}
