//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Armand Grillet on 31/05/2015.
//  Copyright (c) 2015 Armand Grillet. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                  return "\(operand)"
                case .Variable(let variable):
                    return variable
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    var variableValues = ["π": M_PI]
    var description: String {
        get {
            return describe(opStack).description
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-") { $1 - $0 })
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.UnaryOperation("sin") { sin($0) })
        learnOp(Op.UnaryOperation("cos") { cos($0) })
        learnOp(Op.UnaryOperation("√") { sqrt($0) })
    }
    
    private func describe(ops: [Op]) -> (description: String, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                if operand % 1 != 0 {
                    return ("\(operand)", remainingOps)
                } else {
                    return ("\(Int(operand))", remainingOps) // Remove the .O part
                }
            case .Variable(let variable):
                return (variable, remainingOps)
            case .UnaryOperation(_, _):
                let op1 = describe(remainingOps)
                return ("\(op.description)(\(op1.description))", op1.remainingOps)
            case .BinaryOperation(_, _):
                var op1 = describe(remainingOps)
                var op2 = describe(op1.remainingOps)
                
                if ((op.description == "×" || op.description == "/") && (op1.description.rangeOfString("+") != nil  || op1.description.rangeOfString("-") != nil)) {
                    op1.description = "(\(op1.description))"
                }
                
                if ((op.description == "×" || op.description == "/") && (op2.description.rangeOfString("+") != nil  || op2.description.rangeOfString("-") != nil)) {
                    op2.description = "(\(op2.description))"
                }
                
                return (op2.description + op.description + op1.description, op2.remainingOps)
            }
        } else {
            return ("?", ops)
        }
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let variable):
                return (variableValues[variable], remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operand1Evaluation = evaluate(remainingOps)
                if let operand1 = operand1Evaluation.result {
                    let operand2Evaluation = evaluate(operand1Evaluation.remainingOps)
                    if let operand2 = operand2Evaluation.result {
                        return (operation(operand1, operand2), operand2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func clear() {
        opStack = [Op]()
        variableValues = ["π":M_PI]
    }
    
    func getOperations() -> String {
        return opStack.description
    }
    
    func pushOperand(value: Double) -> Double? {
        opStack.append(Op.Operand(value))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
