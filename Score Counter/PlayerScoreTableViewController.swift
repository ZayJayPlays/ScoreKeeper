//
//  PlayerScoreTableViewController.swift
//  Score Counter
//
//  Created by Zane Jones on 3/24/23.
//

import UIKit

class PlayerScoreTableViewController: UITableViewController {

    var playerScores: [PlayerScore] = [PlayerScore(name: "ZayJayPlays", image: UIImage(named: "ZayJayLogo")?.jpegData(compressionQuality: 1), score: 10)] {
        didSet {
            PlayerScore.saveToFile(player: playerScores)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        playerScores = PlayerScore.loadFromFile()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        sortByScore()
    }

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerScores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreKeeperCell", for: indexPath) as! PlayerScoreTableViewCell
        
        cell.playerScore = playerScores[indexPath.row]
        cell.scoreChanged = { value in
            self.playerScores[indexPath.row].score = value
            self.sortByScore()
        }
        return cell
    }
    
    func sortByScore() {
        playerScores = playerScores.sorted{ $0.score! > $1.score!}
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    @IBSegueAction func addPlayer(_ coder: NSCoder) -> PlayerDetailViewController? {
        return PlayerDetailViewController(coder: coder)
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> PlayerDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {fatalError("Only cells should trigger this")}
        return PlayerDetailViewController(coder: coder, player: playerScores[indexPath.row])
    }
    
    
    @IBAction func unwindToScoreboard(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? PlayerDetailViewController else {return}

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            playerScores[selectedIndexPath.row] = sourceViewController.player
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: playerScores.count, section: 0)
            playerScores.append(sourceViewController.player)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            playerScores.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
