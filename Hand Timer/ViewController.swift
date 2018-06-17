//
//  ViewController.swift
//  Object Detection
//
//  Created by Rudra Jikadra on 11/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var b = 0
    @IBOutlet weak var but: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
 
    var mlModel = hand().model
    
    var timer = Timer()
    var fractions: Int = 0
    var seconds: Int = 0
    var minutes: Int = 0
    
    var timerStarted: Bool = false
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        but.isEnabled = true
        
        timerLabel.text = "00:00.00"
        
        but.titleLabel?.textAlignment = NSTextAlignment.center
        but.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //camera
        let captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        
        captureSession.startRunning()
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.opacity = 0
        // camera is created
        
        
        let  dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
                
    }
    
    @IBAction func butTap(_ sender: Any) {
        if b == 0 {
            
            UIView.transition(with: but, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.but.setTitle("", for: .normal)
            }, completion: { (completed) in
                self.but.setTitle(" Well, what if I say you can Control Time? ", for: .normal)
                UIView.transition(with: self.but, duration: 2.0, options: .transitionCrossDissolve, animations: {
                    self.but.alpha = 1
                }, completion: nil)
            })
            
            b = 1
        } else if b == 1 {
            UIView.transition(with: but, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.but.setTitle("", for: .normal)
            }, completion: { (completed) in
                self.but.setTitle(" I'll Prove It To You!\n Just put your hand in front of the back camera....\n\n And\n See The Magic Yourself!", for: .normal)
                UIView.transition(with: self.but, duration: 2.0, options: .transitionCrossDissolve, animations: {
                    self.but.alpha = 1
                }, completion: nil)
            })
            b = 2
        } else {
            UIView.transition(with: but, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.but.setTitle("", for: .normal)
            }, completion: { (completed) in
                self.but.alpha = 0
                self.but.isEnabled = false
                self.previewLayer.opacity = 0.2
            })
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        guard let model = try? VNCoreMLModel(for:  mlModel) else { return }
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            
            DispatchQueue.main.async(){
                
                if firstObservation.identifier == "openFist"{
                    
                    if self.timerStarted == false {
                        
                        self.timerStarted = true
                        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                    }
                    
                } else if firstObservation.identifier == "closedFist" {
                    
                    if self.timerStarted == true {
                        
                        self.timerStarted = false
                        self.timer.invalidate()
                    }
                    
                } else {
                    
                    self.timer.invalidate()
                    
                    self.fractions = 0
                    self.seconds = 0
                    self.minutes = 0
                    
                    self.timerStarted = false
                    self.timerLabel.text = "00:00.00"
                    
                }
            }
//            print(firstObservation.identifier, firstObservation.confidence)
        }

        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
    @objc func updateTimer(){
        fractions += 1
        
        if fractions == 100 {
            fractions = 0
            seconds += 1
        }
        
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        
        
        let fracStr: String = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secStr: String = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minStr: String = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        timerLabel.text = "\(minStr):\(secStr).\(fracStr)"
    }
    
    
}

