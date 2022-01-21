//
//  Extension.swift
//  FollowTheOrder
//
//  Created by Oleh Study on 21.01.2022.
//

import Foundation
import UIKit


extension GameScene {
    func makeImage(name: String) -> UIImage? {
        let image = UIImage(named: name)
        return image ?? nil
    }
    
    var randomNumbersArray: [Int] {
        var array = [Int]()
        for item in 0...9 {
            array.append(item)
        }
        array.shuffle()
        return array
    }

}
