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
    var vehicle = Vehicle()
    var activityIndicator = UIActivityIndicatorView()
    
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
    
    
    @IBAction func didTapConfirmVIN(sender: UIBarButtonItem) {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.activityIndicator.center = self.view.center
        //self.activityIndicator.backgroundColor = UIColor.blueColor()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        
        self.view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        
        let urlPath = "https://api.edmunds.com/api/vehicle/v2/vins/\(scannedVinLabel.text!)?fmt=json&api_key=6hpb5wfpnzecnubrar58w5tv"
        let url = NSURL(string: urlPath)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            
            if error != nil {
                print("getCarInfo - error: \(error)")
            }
            else {
                
                if data != nil {
                    let jsonResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    if let status = jsonResult["status"] as? String {
                        print("VIN: \(status)")
                    }
                    else {
                        /*
                        var image: UIImage?
                        var drivenWheels: String = ""
                        var numOfDoors: Int?
                        var mpg: Dictionary<String, String>?
                        var transmissionType: String?
                        var totalValves: Int = 0
                        var cylinder: Int = 0
                        var horsepower: Int = 0
                        var type: String = ""
                        var vehicleStyle: String = ""
                        */
                        
                        // VIN
                        self.vehicle.setVin(jsonResult["vin"] as! String)
                        
                        // YEAR
                        let arrYears = jsonResult["years"] as! NSArray
                        self.vehicle.setYear(arrYears[0]["year"] as! Int)
                        
                        // MAKE
                        self.vehicle.setMake((jsonResult["make"] as! NSDictionary)["name"] as! String)
                        
                        // MODEL
                        self.vehicle.setModel((jsonResult["model"] as! NSDictionary)["name"] as! String)
                        
                        // DRIVENWHEELS
                        self.vehicle.setDrivenWheels(jsonResult["drivenWheels"] as! String)
                        
                        // DOORS
                        self.vehicle.setNumOfDoors(Int(jsonResult["numOfDoors"] as! String)!)
                        
                        // MPG
                        self.vehicle.setMpgCity(Int((jsonResult["MPG"] as! NSDictionary)["city"] as! String)!)
                        self.vehicle.setMpgHighway(Int((jsonResult["MPG"] as! NSDictionary)["highway"] as! String)!)
                        
                        // TRANSMISSION TYPE
                        self.vehicle.setTransmissionType((jsonResult["transmission"] as! NSDictionary)["transmissionType"] as! String)
                        
                        // TOTAL VALVES
                        self.vehicle.setTotalValves((jsonResult["engine"] as! NSDictionary)["totalValves"] as! Int)
                        
                        // CYLINDER
                        self.vehicle.setCylinder((jsonResult["engine"] as! NSDictionary)["cylinder"] as! Int)
                        
                        // HORSEPOWER
                        self.vehicle.setHorsepower((jsonResult["engine"] as! NSDictionary)["horsepower"] as! Int)
                        
                        // TYPE
                        self.vehicle.setType((jsonResult["engine"] as! NSDictionary)["type"] as! String)
                        
                        // VEHICLE STYLE
                        self.vehicle.setVehicleStyle((jsonResult["categories"] as! NSDictionary)["vehicleStyle"] as! String)
                        
                        //let car_model = jsonResult["model"] as! NSDictionary
                        //let car_makeModel = (jsonResult["model"] as! NSDictionary)["id"] as! String
                        
                        /*if let currentVehicle = self.vehicle {
                        let vehicleArray = [self.vehicle]
                        let vehicleData = NSKeyedArchiver.archivedDataWithRootObject(vehicleArray)
                        NSUserDefaults.standardUserDefaults().setObject(vehicleData, forKey: Asset.USER_DEFAULT_KEY_VEHICLE_ARRAY)
                        }*/
                        //println(car_makeModel)
                        
                        //self.vinLabel.text = vehicle.getVin()
                        //self.carMakeModelLabel.text = "\(vehicle.getMake()) \(vehicle.getModel())"
                        
                        self.activityIndicator.stopAnimating()
                        self.performSegueWithIdentifier("segueShowCarData", sender: self)
                        
                    }
                }
                else {
                    print("data: \(data)")
                }
            }
            
        })
        
        task.resume()
    }
    
    func parseCarData(data: NSDictionary, section: String) -> String {
        let result = data[section] as! String
        
        return result
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
        
        else if segue.identifier == "segueShowCarData" {
            //self.dismissViewControllerAnimated(true, completion: nil)
            let carViewController = segue.destinationViewController as! CarViewController
            carViewController.vehicle = vehicle
        }
    }
}

