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
    
    fileprivate var accumulator = 0.0
    fileprivate var pending: PendingBinaryOperation?
    fileprivate var hasNewAccumulator = false
    fileprivate var hasPartialAccumulator = false
    fileprivate var isConstantPrinted = false
    
    fileprivate var operations = [
        "π": Operation.constant(M_PI),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "×": Operation.binaryOperation({$0 * $1}),
        "÷": Operation.binaryOperation({$0 / $1}),
        "+": Operation.binaryOperation({$0 + $1}),
        "−": Operation.binaryOperation({$0 - $1}),
        "%": Operation.binaryOperation({$0.truncatingRemainder(dividingBy: $1)}),
        "=": Operation.equals
    ]
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    fileprivate struct PendingBinaryOperation {
        let binaryFunction: (Double, Double) -> Double
        let firstOperand: Double
    }
    
    func setOperand(_ operand: Double?) {
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
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if isPartialResult {
                    description += symbol
                    isConstantPrinted = true
                } else {
                    description = symbol
                }
                accumulator = value
            case .unaryOperation(let function):
                if isPartialResult {
                    description += "\(symbol)(\(accumulator))"
                    hasPartialAccumulator = true
                } else {
                    description = "\(symbol)(\(description))"
                }
                accumulator = function(accumulator)
            case .binaryOperation(let function):
                executePendingBinaryOperation()
                description += " \(symbol) "
                pending = PendingBinaryOperation(binaryFunction: function, firstOperand: accumulator)
            case .equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation() {
        if isPartialResult {
            if hasPartialAccumulator {
                hasPartialAccumulator = false
            } else {
                if !isConstantPrinted {
                    description += "\(accumulator)"
                } else {
                    isConstantPrinted = false
                }
            }
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        } else if hasNewAccumulator {
            description = "\(accumulator)"
        }
    }
}
