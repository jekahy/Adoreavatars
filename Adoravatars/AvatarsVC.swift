//
//  ViewController.swift
//  Adoravatars
//
//  Created by Eugene on 21.06.17.
//  Copyright © 2017 Eugene. All rights reserved.
//

import UIKit

class AvatarsVC: UIViewController {

    fileprivate let cellIdentifier = "avatarCell"
    fileprivate let toDownloadsSegue = "toDownloadsVC"
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let manager = AvatarsManager.shared
    fileprivate lazy var avatars:[Avatar] = self.defaultAvatarIDs().map{Avatar(identifier: $0)}

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.title = "Adoreavatars"
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Network", style: .plain, target: self, action: #selector(networkButtonTapped))
    }
    
    
    @objc
    private func networkButtonTapped ()
    {
        performSegue(withIdentifier: toDownloadsSegue, sender: nil)
    }
    
    
    private func defaultAvatarIDs()->[String]
    {
        return ["Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Organa", "Owen Lars", "Beru Whitesun lars", "R5-D4", "Biggs Darklighter", "Obi-Wan Kenobi", "Anakin Skywalker", "Wilhuff Tarkin", "Chewbacca", "Han Solo", "Greedo", "Jabba Desilijic Tiure", "Wedge Antilles", "Jek Tono Porkins", "Yoda", "Palpatine", "Boba Fett", "IG-88", "Bossk", "Lando Calrissian", "Lobot", "Ackbar", "Mon Mothma", "Arvel Crynyd", "Wicket Systri Warrick", "Nien Nunb", "Qui-Gon Jinn", "Nute Gunray", "Finis Valorum", "Jar Jar Binks", "Roos Tarpals", "Rugor Nass", "Ric Olié", "Watto", "Sebulba", "Quarsh Panaka", "Shmi Skywalker", "Darth Maul", "Bib Fortuna", "Ayla Secura", "Dud Bolt", "Gasgano", "Ben Quadinaros", "Mace Windu", "Ki-Adi-Mundi", "Kit Fisto", "Eeth Koth", "Adi Gallia", "Saesee Tiin", "Yarael Poof", "Plo Koon", "Mas Amedda", "Gregar Typho", "Cordé", "Cliegg Lars", "Poggle the Lesser", "Luminara Unduli", "Barriss Offee", "Dormé", "Dooku", "Bail Prestor Organa", "Jango Fett", "Zam Wesell", "Dexter Jettster", "Lama Su", "Taun We", "Jocasta Nu", "Ratts Tyerell", "R4-P17", "Wat Tambor", "San Hill", "Shaak Ti", "Grievous", "Tarfful", "Raymus Antilles", "Sly Moore", "Tion Medon", "Finn", "Rey", "Poe Dameron", "BB8", "Captain Phasma", "Padmé Amidala"]
    }

  }

extension AvatarsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AvatarCell else {
            return UICollectionViewCell.init()
        }
        let avatar = avatars[indexPath.row]
        cell.configure(with: avatar, api: AvatarsManager.shared)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars.count
    }

}

extension AvatarsVC:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = view.frame.size.width/3-20
        return CGSize(width:w , height: w)
    }

}



