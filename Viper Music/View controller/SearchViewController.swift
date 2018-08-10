//
//  ViewController.swift
//  Viper Music
//
//  Created by Anshuman Dash on 7/18/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit
import ReactiveCocoa
import AVFoundation

var audioPlayer = AVAudioPlayer()
var currentTrack: Int = 0
var downloadedTracks = [Int]()
var allTracks = [Track]()

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- IBOutlets
    
    @IBOutlet weak var showTracksTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var musicPlayerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var showMusicImageView: UIImageView!
    @IBOutlet weak var showTrackNameLabel: UILabel!
    @IBOutlet weak var showArtistNameLabel: UILabel!
    @IBOutlet weak var musicStateButton: UIButton!
    @IBOutlet weak var activityViewHeight: NSLayoutConstraint!
    
    //MARK:- Instance Variables
    
    var downloads = 0
    var musicPlayerViewInitialHeight: CGFloat = 0.0
    lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityViewHeight.constant = 0
        
        showTracksTableView.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.1333333333, blue: 0.262745098, alpha: 1)
        activityIndicatorView.isHidden = true
        setUpSearchBar()
        
        musicPlayerViewInitialHeight = musicPlayerViewHeight.constant
        musicPlayerViewHeight.constant = 0
        
        DownloadService.downloadsSession = downloadSession
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if allTracks.count > 0
        {
            if audioPlayer.isPlaying {
                musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            }
            else {
                musicStateButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            }
            
            showMusicImageView.image = ImageHandler.sharedInstance.showTrackImage(imageURL: allTracks[ImageHandler.sharedInstance.updatedTrack].artworkUrl100!)
            
            showTrackNameLabel.text = allTracks[ImageHandler.sharedInstance.updatedTrack].trackName
            showArtistNameLabel.text = allTracks[ImageHandler.sharedInstance.updatedTrack].artistName
        }
    }
    
    //MARK:- UITableView Data Source & Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackTableViewCell.self)) as! TrackTableViewCell
        cell.delegate = self
        cell.populateCell(track: allTracks[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        
        let trackPath = allTracks[indexPath.row].previewUrl
        
        let imageURL = allTracks[indexPath.row].artworkUrl100
        do{
            let imageData = try Data(contentsOf: imageURL!)
            guard let image = UIImage(data: imageData) else {
                return
            }
            
            showMusicImageView.image = image
            showTrackNameLabel.text = allTracks[indexPath.row].trackName
            showArtistNameLabel.text = allTracks[indexPath.row].artistName
            
            currentTrack = indexPath.row
            
            let audiodata = try Data(contentsOf: trackPath!)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try audioPlayer = AVAudioPlayer(data: audiodata)
            audioPlayer.play()
            audioPlayer.volume = 6
            
            if audioPlayer.isPlaying {
                activityIndicatorView.stopAnimating()
                activityIndicatorView.isHidden = true
            }
            
        } catch {
            print(error)
        }
        
        UIView.animate(withDuration: 0.5) {
            self.musicPlayerViewHeight.constant = self.musicPlayerViewInitialHeight
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func openMusicViewButtonTapped(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: String(describing: PlayViewController.self)) as! PlayViewController
        
        controller.trackImage = showMusicImageView.image
        controller.trackName = showTrackNameLabel.text!
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func musicStateButtonTapped(_ sender: Any) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            musicStateButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        else {
            audioPlayer.play()
            musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    //MARK:- Custom Methods
    
    func setUpSearchBar() {
        allTracks = []
        searchBar.reactive.searchButtonClicked.observeValues {
            [unowned self] in
            if var searchString = self.searchBar.text {
                downloadedTracks.removeAll()
                print(downloadedTracks)
                searchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)

                if searchString.count > 0 {
                    self.activityIndicator()
                    SearchHandler.callApi(url: createSearchString(searchKeyword: searchString), completion: { (tracks) in
                        if let track = tracks {
                            DispatchQueue.main.async {
                                allTracks = track
                                self.showTracksTableView.reloadData()
                                
                                if allTracks.count > 0 {
                                    UIView.animate(withDuration: 0.25) {
                                        self.activityIndicatorView.stopAnimating()
                                        self.activityIndicatorView.isHidden = true
                                        self.activityViewHeight.constant = 0
                                    }
                                }
                                else {
                                    let alert = UIAlertController(title: "Oops!", message: "Sorry, Track not present", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(okAction)
                                    self.present(alert, animated: true, completion: nil)
                                    self.activityIndicatorView.stopAnimating()
                                    self.activityIndicatorView.isHidden = true
                                    self.searchBar.text = ""
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func activityIndicator() {
        UIView.animate(withDuration: 0.25) {
            self.activityViewHeight.constant = 40
            self.activityIndicatorView.isHidden = false
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func localFilePath(for url: URL) -> URL {
       return documentsDirectory.appendingPathComponent(url.lastPathComponent)
    }
}

extension SearchViewController: TrackTableViewCellDelegate {
    func downloadButtonTapped(_ cell: TrackTableViewCell) {
        if let indexPath = showTracksTableView.indexPath(for: cell) {
            let track = allTracks[indexPath.row]
            DownloadService.startDownload(track)
            downloadedTracks.append(indexPath.row)
            downloads += 1
        }
    }
    
    func pauseButtonTapped(_ cell: TrackTableViewCell) {
        if let indexPath = showTracksTableView.indexPath(for: cell) {
            let track = allTracks[indexPath.row]
            DownloadService.pauseDownload(track)
        }
    }
    
    func resumeButtonTapped(_ cell: TrackTableViewCell) {
        if let indexPath = showTracksTableView.indexPath(for: cell) {
            let track = allTracks[indexPath.row]
            DownloadService.resumeDownload(track)
        }
    }
    
    func cancelButtonTapped(_ cell: TrackTableViewCell) {
        if let indexPath = showTracksTableView.indexPath(for: cell) {
            let track = allTracks[indexPath.row]
            DownloadService.cancelDownload(track)
        }
    }
}
