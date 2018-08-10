//
//  Download.swift
//  Viper
//
//  Created by Anshuman Dash on 7/24/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class Download {
    var track: Track?
    
    init(currentTrack: Track) {
        self.track = currentTrack
    }
    
    var downloadTask: URLSessionDownloadTask?
    var isDownloading = false
    var isDownloaded = false
    var resumeData: Data?
    var progress: Float = 0
}
