//
//  TrackTableViewCell.swift
//  Viper Music
//
//  Created by Anshuman Dash on 7/18/18.
//  Copyright © 2018 Anshuman Dash All rights reserved.
//

import UIKit
import AlamofireImage

protocol TrackTableViewCellDelegate {
    func downloadButtonTapped(_ cell:TrackTableViewCell)
    func pauseButtonTapped(_ cell:TrackTableViewCell)
    func resumeButtonTapped(_ cell:TrackTableViewCell)
    func cancelButtonTapped(_ cell:TrackTableViewCell)
}

class TrackTableViewCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var songView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var pauseOrResumeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    //MARK:- Instance Variables
    
    var delegate: TrackTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.clipsToBounds = true
        selectionStyle = .none
    }

    //MARK:- Custom Methods
    
    func populateCell(track: Track) {
        songNameLabel.text = track.trackName
        artistLabel.text = track.artistName
        genreLabel.text = track.primaryGenreName
        timeLabel.text = track.trackTimeMillis
        
        if let url = track.artworkUrl100 {
            trackImageView.af_setImage(withURL: url)
        }
        
        buttonStackView.isHidden = true
        if track.isDownloaded {
            downloadButton.isHidden = true
            buttonStackView.isHidden = true
        }
        else {
            downloadButton.isHidden = false
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        downloadButton.isHidden = true
        buttonStackView.isHidden = false
        delegate?.downloadButtonTapped(self)
    }
    
    @IBAction func pauseOrResumeButtontapped(_ sender: UIButton) {
        if pauseOrResumeButton.titleLabel?.text == "Pause" {
            pauseOrResumeButton.setTitle("Resume", for: .normal)
            delegate?.pauseButtonTapped(self)
        }
        else {
            pauseOrResumeButton.setTitle("Pause", for: .normal)
            delegate?.resumeButtonTapped(self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        buttonStackView.isHidden = true
        downloadButton.isHidden = false
        pauseOrResumeButton.setTitle("Pause", for: .normal)
        delegate?.cancelButtonTapped(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
