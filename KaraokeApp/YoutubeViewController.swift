//
//  YoutubeViewController.swift
//  KaraokeApp
//
//  Created by Kishore Baskar on 7/25/17.
//  Copyright © 2017 Kishore Baskar. All rights reserved.
//

import UIKit
import YouTubePlayer
import AVFoundation

class YoutubeViewController: UIViewController, YouTubePlayerDelegate, AVAudioRecorderDelegate {

    var dataFromTable : SearchResultsClass?
    var player : AVAudioPlayer?
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var playerView: YouTubePlayerView!
   
    @IBOutlet var listenButton: UIButton!
    
    @IBAction func listenPressed(_ sender: Any) {
        playerView.stop()
        playerView.play()
        
        let filename = (dataFromTable?.name)! + "qq" + (dataFromTable?.urlId)! + ".m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            player = try AVAudioPlayer(contentsOf: audioFilename)
            guard let player = player else { return }
            player.setVolume(1.0, fadeDuration: TimeInterval(1))
           
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
        
        
    }
    @IBOutlet var recordButton: UIButton!
    
    
    @IBAction func StartRecording(_ sender: Any) {
        if recordButton.currentTitle == "Start Recording"
        {
        playerView.stop()
        playerView.play()
       let filename = (dataFromTable?.name)! + "qq" + (dataFromTable?.urlId)! + ".m4a"
        let audioFilename = getDocumentsDirectory().appendingPathComponent(filename)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
        }
        else
        {
            playerView.stop()
            recordTapped()
            listenButton.isHidden = false
            recordButton.setTitle("Start Recording", for: .normal)
        }
    
    }
    func recordTapped() {
        if audioRecorder == nil {
            
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Successfully Recorded")
        } else {
            
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
   
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "backToSearch", sender: self)
    }
    @IBOutlet var navBar: UINavigationBar!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let url = "http://www.youtube.com/watch?v=" + (dataFromTable?.urlId)!
        playerView.delegate = self
        playerView.playerVars = [
            "playsinline": "1" as String as AnyObject,
            "controls": "0" as AnyObject,
            "showinfo": "0" as AnyObject
        ]
        playerView.loadVideoURL(URL(string: url)!)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwindToHere(_segue: UIStoryboard){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        print("Player Ready!")
        playerView.play()
    }
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState){
        print("Player state changed! \(playerState)")
        //playerView.play()
    }
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}



