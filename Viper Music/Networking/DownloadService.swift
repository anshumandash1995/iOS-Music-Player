//
//  DownloadService.swift
//  Viper
//
//  Created by Anshuman Dash on 7/24/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

class DownloadService {
    
    //MARK:- Instance Variables
    
    static var downloadsSession: URLSession!
    
    static var activeDownloads: [URL:Download] = [:]
    
    //MARK:- Custom Methods
    
    static func startDownload(_ track: Track) {
        let download = Download(currentTrack: track)
        download.downloadTask = downloadsSession.downloadTask(with: track.previewUrl!)
        download.downloadTask!.resume()
        download.isDownloading = true
        activeDownloads[(download.track?.previewUrl)!] = download
    }
    
    static func pauseDownload(_ track: Track) {
        guard let download = DownloadService.activeDownloads[track.previewUrl!] else {return}
        if download.isDownloading {
            download.downloadTask?.cancel(byProducingResumeData: { (data) in
                download.resumeData = data
            })
            download.isDownloading = false
        }
        print("Download Paused")
    }
    
    static func resumeDownload(_ track: Track) {
        guard let download = DownloadService.activeDownloads[track.previewUrl!] else {return}
        if let resumeData = download.resumeData {
            download.downloadTask = downloadsSession.downloadTask(withResumeData: resumeData)
        }
        else {
            download.downloadTask = downloadsSession.downloadTask(with: (download.track?.previewUrl)!)
        }
        download.downloadTask?.resume()
        download.isDownloading = true
        print("Download Resumed")
    }
    
    static func cancelDownload(_ track: Track) {
        if let download = DownloadService.activeDownloads[track.previewUrl!] {
            download.downloadTask?.cancel()
            activeDownloads[track.previewUrl!] = nil
        }
        print("Download Canceled")
    }
}
