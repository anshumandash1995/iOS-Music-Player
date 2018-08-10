//
//  APIManager.swift
//  Viper Music
//
//  Created by Anshuman Dash on 7/18/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class SearchHandler {

    static var dataSourceArray : [Track] = []
    
    typealias QueryResult = ([Track]?) -> ()
    
    static func callApi(url: String, completion: @escaping QueryResult) {
        guard let url = URL(string: url) else {return}
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print("Response :\(response)")
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    createData(dataSource: json!)
                    completion(dataSourceArray)
                }
                catch {
                    print(error)
                }
            }
        }
        dataTask.resume()
    }
    
    static func createData(dataSource: [String:Any]) {
        dataSourceArray = []
        let data = dataSource["results"] as? [[String:Any]]
        for value in data! {
            if let trackName = value["trackName"] as? String,
                let artistName = value["artistName"] as? String,
                let primaryGenreName = value["primaryGenreName"] as? String,
                let collectionName = value["collectionName"] as? String,
                let trackTimeMillis = value["trackTimeMillis"] as? Int,
                let previewUrlString = value["previewUrl"] as? String,
                let previewURL = URL(string: previewUrlString),
                let artworkUrl100String = value["artworkUrl100"] as? String,
                let artworkUrl100 = URL(string: artworkUrl100String)
            {
                let trackTime = formatTime(milliSeconds: trackTimeMillis)
                
                let dataModel = Track(trackName: trackName, artistName: artistName, primaryGenreName: primaryGenreName, previewUrl: previewURL, artworkUrl100: artworkUrl100, collectionName: collectionName, trackTimeMillis: trackTime, isDownloaded: false)
                dataSourceArray.append(dataModel)
            }
        }
    }
    
    static func formatTime(milliSeconds: Int) -> String {
        
        let sec = milliSeconds/1000
        let minutes = String(sec/60)
        var seconds = String(sec%60)

        if seconds.count == 1 {
            seconds = seconds + "0"
        }
        return minutes + ":" + seconds
    }
}
