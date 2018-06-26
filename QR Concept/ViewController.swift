//
//  ViewController.swift
//  QR Concept
//
//  Created by James Lincoln on 28/2/18.
//  Copyright © 2018 CAS Development. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var viewPreview: UIView!
    
    let notfi = NotificationCenter.default;
    
    var QRData:String = "";
    let avCaptureSession = AVCaptureSession();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        notfi.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil);
        notfi.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil);
    }
    
    @objc func appMovedToBackground()
    {
        avCaptureSession.stopRunning();
        print("Stopped avCaptureSession; Reason: Entering Background");
    }
   
    @objc func appMovedToForeground()
    {
        if (!avCaptureSession.isRunning)
        {
            avCaptureSession.startRunning();
            print("Started avCaptureSession; Reason: Returning to Foregorund");
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        if QRData == "" {
            do {
                print("ex:scanQR()");
                try
                    scanQR();
            } catch  {
                print ("Failed to Scan QR/Barcode")
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum error: Error {
        case noCamera
        case cameraInitFail
    }
    
    func scanQR() throws {
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print ("No Camera!")
            throw error.noCamera
        }
        
        guard let avCaptureInput = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("Camera init Error")
            throw error.cameraInitFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        
        //avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        
        avCaptureSession.addInput(avCaptureInput);
        avCaptureSession.addOutput(avCaptureMetadataOutput);
        
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureMetadataOutput.metadataObjectTypes = [.qr]
        
        let avCaptureViewPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        avCaptureViewPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureViewPreviewLayer.frame = viewPreview.bounds
        
        self.viewPreview.layer.addSublayer(avCaptureViewPreviewLayer)
        
        avCaptureSession.startRunning()
        
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)    {
        if metadataObjects.count > 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                print(object.stringValue!)
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    if (avCaptureSession.isRunning) { avCaptureSession.stopRunning(); print("Stopped avCaptureSession"); }
                    QRData = object.stringValue!
                    print("Code Read: \(object.stringValue!)")
                    self.performSegue(withIdentifier: "showQRDetails", sender: nil);
                    return;
                } else {
                    print("Should not get here...")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQRDetails" {
            if let controller = segue.destination as? DetailsViewController
            {
                print("Segue: \(QRData)")
                controller.QRData = QRData
            }
        }
    }

}

