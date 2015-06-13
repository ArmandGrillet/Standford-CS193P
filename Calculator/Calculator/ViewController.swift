//
//  ViewController.swift
//  Calculator
//
//  Created by Armand Grillet on 01/02/2015.
//  Copyright (c) 2015 Armand Grillet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    let history = UIAlertView(title: "History", message: nil, delegate: nil, cancelButtonTitle: "OK")
    
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    var displayValue: Double? {
        get {
            if let displayedText = display.text {
                if let displayedNumber = NSNumberFormatter().numberFromString(displayedText) {
                    return displayedNumber.doubleValue
                }
            }
            return nil
        }
        set {
            if let value = newValue {
                if value != 0 {
                    if value % 1 != 0 {
                        display.text = "=\(value)"
                    } else {
                    display.text = "=\(Int(value))" // Remove the .O part
                    }
                } else {
                    display.text = "0"
                }
            } else {
                display.text = " "
            }
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            if (digit == "." && display.text!.rangeOfString(".") != nil) {
                return
            } else {
               display.text! += digit
            }
        } else {
            if digit == "." {
                display.text = "0."
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func assignVariable(sender: UIButton) {
        let variable = dropFirst(sender.currentTitle!) // Remove the arrow
        if let value = displayValue {
            brain.variableValues[variable] = value
            userIsInTheMiddleOfTypingANumber = false
            displayValue = brain.evaluate()
        }
    }
    
    @IBAction func appendVariable(sender: UIButton) {
        brain.pushOperand(sender.currentTitle!)
        userIsInTheMiddleOfTypingANumber = false
        display.text = sender.currentTitle!
    }
    
    @IBAction func operate(sender: UIButton) {
        enter() // Push the number displayed in the brain
        let operation = sender.currentTitle!
        switch operation {
        case "+", "-", "×", "÷", "sin", "cos", "√":
            displayValue = brain.performOperation(operation)
        default: break
        }
    }
    
    @IBAction func changeSign() {
        if let displayedValue = displayValue {
            let newValue = -1 * displayedValue
            if newValue % 1 != 0 {
                display.text = "\(newValue)"
            } else {
                display.text = "\(Int(newValue))" // Remove the .O part
            }
        }
    }
    
    @IBAction func showHistory() {
        history.message = brain.description
        history.show()
    }
    
    @IBAction func clear() {
        displayValue = 0
        brain.clear()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let operand = displayValue {
            brain.pushOperand(operand)
        }
    }
}

