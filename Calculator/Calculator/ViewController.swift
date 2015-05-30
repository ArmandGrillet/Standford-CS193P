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
            if newValue % 1 != 0 {
                display.text = "\(newValue)"
            } else {
                display.text = "\(Int(newValue))" // Remove the .O part
            }
            userIsInTheMiddleOfTypingANumber = false
            operandStack.append(displayValue)
            addContentHistory(display.text!)
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
    
    @IBAction func operate(sender: UIButton) {
        enter()
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
            case "√": performOperation {sqrt($0)}
            default: break
        }
    }
    
    @IBAction func conjure(sender: UIButton) {
        let value = sender.currentTitle!
        switch value {
            case "π": display.text = String(stringInterpolationSegment: M_PI)
            default: break
        }
    }
    
    private func performOperation(operation : (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            let secondOperand = operandStack.removeLast()
            let firstOperand = operandStack.removeLast()
            displayValue = operation(firstOperand, secondOperand)
        }
    }
    
    private func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
        }
    }
    
    @IBAction func changeSign() {
        if userIsInTheMiddleOfTypingANumber {
            self.display.text = "\(-1 * self.displayValue)"
        } else {
            displayValue = -1 * (operandStack.removeLast())
        }
    }
    
    @IBAction func clear() {
        displayValue = 0
        operandStack = Array<Double>()
        history.text = ""
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        addContentHistory(display.text!)
    }
    
    private func addContentHistory(content: String) {
        if history.text != "" {
            history.text! += " | " + content
        } else {
            history.text = content
        }
    }
}

