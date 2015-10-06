//
//  HomeViewController.swift
//  Barcode Two
//
//  Created by Andi Setiyadi on 10/6/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var scannedVin: String?
    @IBOutlet weak var scannedVinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if let scannedVin = scannedVin {
            scannedVinLabel.text = scannedVin
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //let scannerViewController = segue.destinationViewController as! ScannerViewController

    }
    
    @IBAction func unwindFromScanner(segue: UIStoryboardSegue) {
        print("scanned vin = \(scannedVin)")
        scannedVinLabel.text = scannedVin
    }

}
