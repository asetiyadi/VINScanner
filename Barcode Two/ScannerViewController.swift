//
//  ViewController.swift
//  Barcode Two
//
//  Created by Andi Setiyadi on 10/4/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var scannedVinLabel: UILabel!
    @IBOutlet weak var scannerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerView.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypePDF417Code,
                AVMetadataObjectTypeCode39Code,
                AVMetadataObjectTypeCode39Mod43Code]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = scannerView.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        scannerView.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        print(code)
        var vinCode: String = code
        
        if code.characters.count == 18 {
            vinCode = code.stringByReplacingCharactersInRange(code.startIndex..<code.startIndex.successor(), withString: "")

        }
        
        scannedVinLabel.text = vinCode
        
        /*let alert = UIAlertController(title: "VIN", message: code, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.captureSession.stopRunning()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Rescan", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.captureSession.startRunning()
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(alert, animated: true, completion: nil)*/
    }
    
    
    @IBAction func didTapRescan(sender: UIBarButtonItem) {
        scannedVinLabel.text = ""
        self.captureSession.startRunning()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("after scan: \(scannedVinLabel.text!)")
        if segue.identifier == "segueUnwindFromScanner" {
            let homeController = segue.destinationViewController as! HomeViewController
            homeController.scannedVin = scannedVinLabel.text!
        }
    }
}

