//
//  CarViewController.swift
//  VIN Scanner
//
//  Created by Andi Setiyadi on 10/12/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class CarViewController: UIViewController {

    var vehicle: Vehicle?
    
    @IBOutlet weak var vehicle_vin: UILabel!
    
    @IBOutlet weak var vehicleVinLabel: UILabel!
    @IBOutlet weak var vehicleYearLabel: UILabel!
    @IBOutlet weak var vehicleMakeLabel: UILabel!
    @IBOutlet weak var vehicleModelLabel: UILabel!
    @IBOutlet weak var vehicleDrivenWheelsLabel: UILabel!
    @IBOutlet weak var vehicleNumOfDoorsLabel: UILabel!
    @IBOutlet weak var vehicleMpgHighwayLabel: UILabel!
    @IBOutlet weak var vehicleMpgCityLabel: UILabel!
    @IBOutlet weak var vehicleTransmissionTypeLabel: UILabel!
    @IBOutlet weak var vehicleValvesLabel: UILabel!
    @IBOutlet weak var vehicleCylinderLabel: UILabel!
    @IBOutlet weak var vehicleHorsepowerLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var vehicleStyleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("myvehicle: \(vehicle)")
        // Do any additional setup after loading the view.
        
        vehicleVinLabel.text = vehicle!.getVin()
        vehicleYearLabel.text = String(vehicle!.getYear())
        vehicleMakeLabel.text = vehicle!.getMake()
        vehicleModelLabel.text = vehicle!.getModel()
        vehicleDrivenWheelsLabel.text = vehicle!.getDrivenWheels()
        vehicleNumOfDoorsLabel.text = String(vehicle!.getNumOfDoors())
        vehicleMpgHighwayLabel.text = String(vehicle!.getMpgHighway())
        vehicleMpgCityLabel.text = String(vehicle!.getMpgCity())
        vehicleTransmissionTypeLabel.text = vehicle!.getTransmissionType()
        vehicleValvesLabel.text = String(vehicle!.getTotalValves())
        vehicleCylinderLabel.text = String(vehicle!.getCylinder())
        vehicleHorsepowerLabel.text = String(vehicle!.getHorsepower())
        vehicleTypeLabel.text = vehicle!.getType()
        vehicleStyleLabel.text = vehicle!.getVehicleStyle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
