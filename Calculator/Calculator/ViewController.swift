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
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if !(digit == "." && display.text!.rangeOfString(".") != nil) {
            if userIsInTheMiddleOfTypingANumber {
                display.text! += digit
            } else {
                display.text = digit
                userIsInTheMiddleOfTypingANumber = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        addContentHistory(operation)
        switch operation {
        case "×": performOperation {$0 * $1}
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$0 / $1}
        case "+": performOperation {$0 + $1}
        case "-": performOperation {$0 - $1}
        case "sin": performOperation {sin($0)}
        case "cos": performOperation {cos($0)}
        case "π": performOperation {M_PI}
        case "√": performOperation {sqrt($0)}
        default: break
        }
    }
    
    func performOperation(operation : (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: () -> Double) {
        displayValue = operation()
    }
    
    @IBAction func changeSign() {
        if userIsInTheMiddleOfTypingANumber {
            self.display.text = "\(-1 * self.displayValue)"
        } else {
            displayValue = -1 * (operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear() {
        operandStack = Array<Double>()
        displayValue = 0
        history.text = ""
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        addContentHistory(display.text!)
    }
    
    func addContentHistory(content: String) {
        if history.text != "" {
            history.text! += " | " + content
        } else {
            history.text = content
        }
    }
}

