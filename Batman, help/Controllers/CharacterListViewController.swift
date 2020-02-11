//
//  CharacterListViewController.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 11/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var characterCollection: UICollectionView!
    
    var charactersDatabase: DatabaseAccess = Singleton.shared
    var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterCollection.dataSource = self
        characterCollection.delegate = self
        
        charactersDatabase.getAllCharacters({
            self.characters = $0
            self.characterCollection.reloadData()
        })

        // Do any additional setup after loading the view.
    }
    
}

// MARK: - UICollectionViewDataSource
extension CharacterListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCollectionViewCell
        
        print("Setting cell \(indexPath.item)")
        cell.setupCell(with: characters[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = characterCollection.frame.height * 0.35
        let width = characterCollection.frame.width * 0.47
        
        return CGSize(width: width, height: height)
    }
    
}
