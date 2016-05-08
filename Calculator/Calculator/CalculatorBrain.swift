//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Armand Grillet on 01/05/2016.
//  Copyright © 2016 Armand Grillet. All rights reserved.
//

import Foundation

class CalculatorBrain {
    var result: Double {
        get {
            return accumulator
        }
    }
    
    var description = ""
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    private var accumulator = 0.0
    private var pending: PendingBinaryOperation?
    private var hasNewAccumulator = false
    private var hasPartialAccumulator = false
    
    private var operations = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "%": Operation.BinaryOperation({$0 % $1}),
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation(Double -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperation {
        let binaryFunction: (Double, Double) -> Double
        let firstOperand: Double
    }
    
    func setOperand(operand: Double?) {
        if operand != nil {
            accumulator = operand!
            hasNewAccumulator = true
        } else {
            hasNewAccumulator = false
        }
        
        if description == "" {
            description = "\(operand)"
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                if isPartialResult {
                    description += symbol
                } else {
                    description = symbol
                }
                accumulator = value
            case .UnaryOperation(let function):
                if isPartialResult {
                    description += "\(symbol)(\(accumulator))"
                    hasPartialAccumulator = true
                } else {
                    description = "\(symbol)(\(description))"
                }
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                description += " \(symbol) "
                pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation() {
        if isPartialResult {
            if hasPartialAccumulator {
                hasPartialAccumulator = false
            } else {
                description += "\(accumulator)"
            }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        } else if hasNewAccumulator {
            description = "\(accumulator)"
        }
    }
}