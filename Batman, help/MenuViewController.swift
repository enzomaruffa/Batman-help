//
//  MenuViewController.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuContainer.layer.cornerRadius = menuContainer.frame.height/2
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        // Show other menu options
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
