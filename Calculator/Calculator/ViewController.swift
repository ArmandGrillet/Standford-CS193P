//
//  ViewController.swift
//  Calculator
//
//  Created by Armand Grillet on 30/04/2016.
//  Copyright © 2016 Armand Grillet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private weak var display: UILabel!
    
    private var brain = CalculatorBrain()
    private var userInTheMiddleOfTyping = false
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
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

    @IBAction func performOperation(sender: UIButton) {
        brain.setOperand(displayValue)
        userInTheMiddleOfTyping = false
        brain.performOperation(sender.currentTitle!)
        displayValue = brain.result
    }
}

