//
//  ViewController.swift
//  Calculator
//
//  Created by Armand Grillet on 30/04/2016.
//  Copyright © 2016 Armand Grillet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet fileprivate weak var history: UILabel!
    @IBOutlet fileprivate weak var display: UILabel!
    
    fileprivate var brain = CalculatorBrain()
    fileprivate var userInTheMiddleOfTyping = false
    fileprivate var userEnteredFloatingPoint = false
    fileprivate var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if newValue.truncatingRemainder(dividingBy: 1) == 0 {
                display.text = String(format: "%.0f", newValue)
            } else {
               display.text = String(newValue)
            }
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            display.text! += digit
        } else {
            display.text = digit
        }
        userInTheMiddleOfTyping = true
    }

    @IBAction func touchFloatingPoint() {
        if userInTheMiddleOfTyping && !userEnteredFloatingPoint {
            display.text! += "."
            userEnteredFloatingPoint = true
        }
    }
    
    @IBAction func clearEverything() {
        userInTheMiddleOfTyping = false
        userEnteredFloatingPoint = false
        brain = CalculatorBrain()
        displayValue = brain.result
        history.text = " "
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        } else {
            brain.setOperand(nil)
        }
        userInTheMiddleOfTyping = false
        userEnteredFloatingPoint = false
        brain.performOperation(sender.currentTitle!)
        displayHistory()
        displayValue = brain.result
    }
    
    fileprivate func displayHistory() {
        var description = brain.description
        description = description.replacingOccurrences(of: ".0", with: "")
        if brain.isPartialResult {
            history.text = description + " ... "
        } else if description != "" {
            history.text = description + " = "
        }
    }
}

