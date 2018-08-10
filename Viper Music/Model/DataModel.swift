//
//  dataModel.swift
//  Viper Music
//
//  Created by Anshuman Dash on 7/18/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

struct Track {
    var trackName: String
    var artistName: String
    var primaryGenreName: String
    var previewUrl: URL?
    var artworkUrl100 : URL?
    var collectionName: String
    var trackTimeMillis: String?
    var isDownloaded: Bool = false
}
