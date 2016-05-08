//
//  ViewController.swift
//  Calculator
//
//  Created by Armand Grillet on 30/04/2016.
//  Copyright © 2016 Armand Grillet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var history: UILabel!
    @IBOutlet private weak var display: UILabel!
    
    private var brain = CalculatorBrain()
    private var userInTheMiddleOfTyping = false
    private var userEnteredFloatingPoint = false
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            if newValue % 1 == 0 {
                display.text = String(format: "%.0f", newValue)
            } else {
               display.text = String(newValue)
            }
        }
    }
    
    @IBAction func touchDigit(sender: UIButton) {
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
    
    @IBAction func performOperation(sender: UIButton) {
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
    
    private func displayHistory() {
        var description = brain.description
        description = description.stringByReplacingOccurrencesOfString(".0", withString: "")
        if brain.isPartialResult {
            history.text = description + " ... "
        } else if description != "" {
            history.text = description + " = "
        }
    }
}

