//
//  SessionDelegates.swift
//  Viper
//
//  Created by Anshuman Dash on 7/24/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit

extension SearchViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
        print("Finished Downloading")
        
        for currentDownload in downloadedTracks {
            allTracks[currentDownload].isDownloaded = true
            DispatchQueue.main.async {
                self.reload(currentDownload)
            }
        }
        
        guard let sourceURL = downloadTask.originalRequest?.url else {return}
        _ = DownloadService.activeDownloads[sourceURL]
        DownloadService.activeDownloads[sourceURL] = nil
        
        let destinationURL = localFilePath(for: sourceURL)
        print(destinationURL)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func reload(_ row: Int) {
        showTracksTableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}
