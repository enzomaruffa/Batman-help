//
//  CKAsset+.swift
//  Batman, help
//
//  Created by Enzo Maruffa Moreira on 11/02/20.
//  Copyright © 2020 Enzo Maruffa Moreira. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

// MARK: - CKAsset
extension CKAsset {
    func toUIImage() -> UIImage? {
        if let url = self.fileURL,
            let data = NSData(contentsOf: url) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
