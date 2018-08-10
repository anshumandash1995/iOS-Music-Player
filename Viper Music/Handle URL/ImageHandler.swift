//
//  Handlers.swift
//  Viper
//
//  Created by Anshuman Dash on 7/24/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class ImageHandler {
    
    static var sharedInstance = ImageHandler()
    
    private init() {}
    
    var image : UIImage?
    var updatedTrack: Int = 0
    
    func showTrackImage(imageURL: URL) -> UIImage {
        do {
            let data = try Data(contentsOf: imageURL)
            image = UIImage(data: data)
        }
        catch {
            print(error)
        }
        return image!
    }
}
