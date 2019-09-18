//
//  ViewController.swift
//  ContinuousVideoRecoding
//
//  Created by Lilia Dassine BELAID on 9/18/19.
//  Copyright © 2019 Lilia Dassine BELAID. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet var cameraView: UIView!
    
    var captureSession = AVCaptureSession()
    var capturePhotoOutput = AVCapturePhotoOutput()
    var captureMovieFileOutput = AVCaptureMovieFileOutput()
    var captureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    var timer = Timer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cameraView = self.view
        
        //Set device session video and audio
        let session = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let devices = session.devices
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                do {
                    let captureDeviceInput = try AVCaptureDeviceInput(device: device )
                    let captureDeviceInputAudio = try AVCaptureDeviceInput(device: audioDevice)
                    
                    if captureSession.canAddInput(captureDeviceInput){
                        captureSession.addInput(captureDeviceInput)
                        captureSession.addInput(captureDeviceInputAudio)
                        capturePhotoOutput.isLivePhotoCaptureEnabled = capturePhotoOutput.isLivePhotoCaptureSupported
                        
                        if captureSession.canAddOutput(capturePhotoOutput) {
                            captureSession.addOutput(capturePhotoOutput)
                            
                            //Set the video layer
                            captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            captureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                            captureVideoPreviewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(captureVideoPreviewLayer)
                            captureVideoPreviewLayer.position = CGPoint(x: self.cameraView.frame.width / 2, y: self.cameraView.frame.height / 2)
                            captureVideoPreviewLayer.bounds = cameraView.frame
                        }
                        
                        captureSession.addOutput(captureMovieFileOutput)
                        captureSession.startRunning()
                        self.handleCaptureSession()
                    }
                } catch {
                    print("Something went wrong: \(error)")
                }
            }
        }
    }
    
    func handleCaptureSession() {
        print("Start recording")
        //Set saved output for
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let fileName = dateString + "-record.mov"
        
        let fileUrl = paths[0].appendingPathComponent(fileName)
        
        try? FileManager.default.removeItem(at: fileUrl)
        self.captureMovieFileOutput.startRecording(to: fileUrl, recordingDelegate: self)
        
        //Save record every 5 sec. This can be set to 27 for 30 sec recording
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            print("Stop recording")
            self.captureMovieFileOutput.stopRecording()
        })
    }
    
    // AVCaptureFileOutputRecordingDelegate  - fileOutput
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // save video to camera roll
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            print("Saved file: \(outputFileURL.path)")
            self.handleCaptureSession()
        }
    }
}

