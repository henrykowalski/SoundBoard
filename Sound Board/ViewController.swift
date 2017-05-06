//
//  ViewController.swift
//  Sound Board
//
//  Created by Andrzej Palec on 01/05/2017.
//  Copyright © 2017 Andrzej Palec. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sounds : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            sounds = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {}
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
        
        cell.textLabel?.text = sound.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sound = sounds[indexPath.row]
        do {
            audioPlayer = try AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        } catch {}
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Summarization
        // if the editing style is delete than...
        if editingStyle == .delete {
            // ...we gonna grab the sound, grab the context...
            let sound = sounds[indexPath.row]
            // ...we gonna use that context to say delete the sound...
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(sound)
            // ...we gonna save...
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            // ... and then we gonna go get the new stuff that's in core data and put in array and reload the table 
            do {
                sounds = try context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
    }
}
