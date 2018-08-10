//
//  Constant.swift
//  Viper Music
//
//  Created by Anshuman Dash on 7/18/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

let BASE_URL = "https://itunes.apple.com/search?"

func createSearchString(searchKeyword: String) -> String{
    let searchString = searchKeyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    let urlString = "term=\(searchString!)&media=music&entity=musicTrack"
    
    return BASE_URL + urlString
}
