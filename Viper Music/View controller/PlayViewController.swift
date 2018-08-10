//
//  PlayViewController.swift
//  Viper Music
//
//  Created by Anshuman Dash on 7/19/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var showTrackimageView: UIImageView!
    @IBOutlet weak var showTrackNameLabel: UILabel!
    @IBOutlet weak var musicStateButton: UIButton!
    @IBOutlet weak var trackSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var sliderStartTimeLabel: UILabel!
    @IBOutlet weak var sliderEndTimeLabel: UILabel!
    
    //MARK:- Instance Variables
    
    var trackImage: UIImage?
    var trackName = ""
    var startTime = 0.0
    var endTime = 30.0
    var updateVolume: Float = 6
    
    //MARK:- View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTrackimageView.layoutIfNeeded()
        showTrackimageView.layer.cornerRadius = showTrackimageView.frame.size.height/6
        updatePlayer()
        
        _  = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        volumeSlider.value = updateVolume
    }
    
    //MARK:- IBActions
    
    @IBAction func crossButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func musicStateButtonTapped(_ sender: UIButton) {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
            musicStateButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
        else {
            audioPlayer.play()
            musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            startTime = Double(trackSlider.value)
            endTime = Double(trackSlider.maximumValue) - startTime
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        if currentTrack < allTracks.count - 1 {
            audioPlayer.stop()
            currentTrack = currentTrack + 1
            ImageHandler.sharedInstance.updatedTrack = currentTrack
            showTrackNameLabel.text = allTracks[currentTrack].trackName
            showTrackimageView.image = ImageHandler.sharedInstance.showTrackImage(imageURL: allTracks[currentTrack].artworkUrl100!)
            playSong(audioURL: allTracks[currentTrack].previewUrl!)
            startTime = 0
            endTime = 30
            musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        if currentTrack > 0 {
            audioPlayer.stop()
            currentTrack = currentTrack - 1
            ImageHandler.sharedInstance.updatedTrack = currentTrack
            showTrackNameLabel.text = allTracks[currentTrack].trackName
            showTrackimageView.image = ImageHandler.sharedInstance.showTrackImage(imageURL: allTracks[currentTrack].artworkUrl100!)
            playSong(audioURL: allTracks[currentTrack].previewUrl!)
            startTime = 0
            endTime = 30
            musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    @IBAction func trackSliderAction(_ sender: UISlider) {
        if audioPlayer.isPlaying {
            audioPlayer.stop()
            audioPlayer.currentTime = TimeInterval(trackSlider.value)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            startTime = Double(trackSlider.value)
            endTime = Double(30 - startTime)
            musicStateButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        audioPlayer.volume = sender.value
        updateVolume = sender.value
    }
    
    //MARK:- Custom Methods
    
    func updatePlayer() {
        showTrackimageView.image = trackImage
        showTrackNameLabel.text = trackName
    }
    
    func playSong(audioURL: URL){
        do{
        let audiodata = try Data(contentsOf: audioURL)
        try audioPlayer = AVAudioPlayer(data: audiodata)
        audioPlayer.play()

        }
        catch {
            print(error)
        }
    }
    
    @objc func updateSlider() {
        trackSlider.value = Float(audioPlayer.currentTime)
        
        if audioPlayer.isPlaying {
            startTime = startTime + 0.1
            endTime = endTime - 0.1
            
            let sliderStartTime = Int(startTime)
            let SliderEndTime = Int(endTime)
            
            sliderStartTimeLabel.text = String(sliderStartTime)
            if SliderEndTime > 0 {
                sliderEndTimeLabel.text = "-" + String(SliderEndTime)
            }
            else {
                sliderEndTimeLabel.text = String(SliderEndTime)
            }
        }
        else {
            musicStateButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            if trackSlider.value == 0.0 {
                startTime = 0
                endTime = 30
                
                let resetStartTime = Int(startTime)
                let resetEndTime = Int(endTime)
                
                sliderStartTimeLabel.text = String(resetStartTime)
                sliderEndTimeLabel.text = String(resetEndTime)
            }
        }
    }
}
