//
//  DatabaseAccess.swift
//  Batman
//
//  Created by Enzo Maruffa Moreira on 06/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation

protocol DatabaseAccess {
    func getAllCharacters(_ closure: @escaping ([Character]) -> ())
    func getAllScenes(_ closure: @escaping ([SceneLocation]) -> ())
    func addScene(scene: SceneLocation)
    func updateScene(_ scene: SceneLocation)
}
