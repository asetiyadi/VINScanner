//
//  Vehicle.swift
//  AutoInspection
//
//  Created by Andi Setiyadi on 8/17/15.
//  Copyright (c) 2015 Andi Setiyadi. All rights reserved.
//

import Foundation
import UIKit

class Vehicle {
    var year: Int?
    var make: String = ""
    var model: String = ""
    var vin: String = ""
    var image: UIImage?
    var drivenWheels: String = ""
    var numOfDoors: Int = 0
    var mpgCity: Int = 0
    var mpgHighway: Int = 0
    var transmissionType: String = ""
    var totalValves: Int = 0
    var cylinder: Int = 0
    var horsepower: Int = 0
    var type: String = ""
    var vehicleStyle: String = ""
    
    
    init() {
    }
    
    func getYear() -> Int {
        return year!
    }
    func setYear(year: Int) {
        self.year = year
    }
    
    func getMake() -> String {
        return make
    }
    func setMake(make: String) {
        self.make = make
    }
    
    func getModel() -> String {
        return model
    }
    func setModel(model: String) {
        self.model = model
    }
    
    func getVin() -> String {
        return vin
    }
    func setVin(vin: String) {
        self.vin = vin
    }
    
    func getImage() -> UIImage {
        return image!
    }
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func getDrivenWheels() -> String {
        return drivenWheels
    }
    func setDrivenWheels(drivenWheels: String) {
        self.drivenWheels = drivenWheels
    }
    
    func getNumOfDoors() -> Int {
        return numOfDoors
    }
    func setNumOfDoors(numOfDoors: Int) {
        self.numOfDoors = numOfDoors
    }
    
    func getMpgCity() -> Int {
        return mpgCity
    }
    func setMpgCity(mpgCity: Int) {
        self.mpgCity = mpgCity
    }
    
    func getMpgHighway() -> Int {
        return mpgHighway
    }
    func setMpgHighway(mpgHighway: Int) {
        self.mpgHighway = mpgHighway
    }
    
    func getTransmissionType() -> String {
        return transmissionType
    }
    func setTransmissionType(transmissionType: String) {
        self.transmissionType = transmissionType
    }
    
    func getTotalValves() -> Int {
        return totalValves
    }
    func setTotalValves(totalValves: Int) {
        self.totalValves = totalValves
    }
    
    func getCylinder() -> Int {
        return cylinder
    }
    func setCylinder(cylinder: Int) {
        self.cylinder = cylinder
    }
    
    func getHorsepower() -> Int {
        return horsepower
    }
    func setHorsepower(horsepower: Int) {
        self.horsepower = horsepower
    }
    
    func getType() -> String {
        return type
    }
    func setType(type: String) {
        self.type = type
    }
    
    func getVehicleStyle() -> String {
        return vehicleStyle
    }
    func setVehicleStyle(vehicleStyle: String) {
        self.vehicleStyle = vehicleStyle
    }
}
