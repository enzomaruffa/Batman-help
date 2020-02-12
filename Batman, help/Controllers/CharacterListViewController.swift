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
    @IBOutlet weak var characterSegmented: UISegmentedControl!
    
    var charactersDatabase: DatabaseAccess = Singleton.shared
    var charactersSource: [Character] = []
    var characters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterSegmented.selectedSegmentIndex = 1
        
        characterCollection.dataSource = self
        characterCollection.delegate = self
        
        charactersDatabase.getAllCharacters({
            self.characters = $0
            self.charactersSource = $0
            self.characterCollection.reloadData()
        })
        

        self.characterSegmented.selectedSegmentTintColor = .black
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func characterSegmentedChange(_ sender: Any) {
        let filter = characterSegmented.selectedSegmentIndex
        if filter == 0 {
            self.characters = self.charactersSource.filter({ $0.type == .hero })

            UIView.animate(withDuration: 0.4) {
                self.characterSegmented.selectedSegmentTintColor = UIColor.neon
            }
        } else if filter == 1 {
            self.characters = self.charactersSource

            UIView.animate(withDuration: 0.4) {
                self.characterSegmented.selectedSegmentTintColor = .black
            }
        } else if filter == 2 {
            self.characters = self.charactersSource.filter({ $0.type == .villain })

            UIView.animate(withDuration: 0.4) {
                self.characterSegmented.selectedSegmentTintColor = UIColor.neonRed
            }
        }

        
        characterCollection.performBatchUpdates({
            let indexSet = IndexSet(integer: 0)
            self.characterCollection.reloadSections(indexSet)
        }, completion: nil)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "table" {
            if let characterIndex = sender as? Int,
                let vc = segue.destination as? CharacterTableViewController {
                vc.character = characters[characterIndex]
            }
        }
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


// MARK: - UICollectionViewDelegate
extension CharacterListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "table", sender: indexPath.item)
    }
}
