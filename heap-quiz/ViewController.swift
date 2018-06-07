//
//  ViewController.swift
//  heap-quiz
//
//  Created by Virak Ngauv on 6/7/18.
//  Copyright © 2018 Virak Ngauv. All rights reserved.
//
//  Test answer (sum of medians modulo 10000): 9335
//  Start time: 6/7/18, 3:07pm
//  End time: 6/7/18, 7:14pm

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Initialize heap-quiz or heap-test
        let quizName = "heap-quiz"
        guard let quizFilePath = Bundle.main.path(forResource: quizName, ofType: "txt") else {print("error trying to get file from bundle"); return}
        guard let quizArray = arrayFromContentsOfFileWithPath(path: quizFilePath) else {print("error trying to write array from file to object"); return}
        
        //Uncomment below to test file quizName
        print(medianCruncher(withArray: quizArray))
    }
    
    func medianCruncher (withArray array : [Int]) -> Int {
        var medianSum : Int = 0
        var smallArray = [Int]()
        var bigArray = [Int]()
        func insertInt (_ int : Int, intoArray array : inout [Int], intoSmallArray : Bool) {
            var int = int
            if intoSmallArray {int = -1 * int}
            
            array.append(int)
            
            if array.count == 1 {return}
            
            var newValueIndex = array.count-1
            var newValueParentIndex = newValueIndex % 2 == 0 ? (newValueIndex-2)/2 : (newValueIndex-1)/2
            
            while array[newValueParentIndex] > array[newValueIndex] {
                //Swap values
                (array[newValueParentIndex], array[newValueIndex]) = (array[newValueIndex], array[newValueParentIndex])
                //Fix indices for newValue and its new parent from above swap
                newValueIndex = newValueParentIndex
                newValueParentIndex = newValueIndex % 2 == 0 ? (newValueIndex-2)/2 : (newValueIndex-1)/2
                //If newValue makes its way to the root, then exit function
                if newValueParentIndex == -1 {return}
            }
        }
        func extractRoot (ofArray array : inout [Int], extractMin : Bool) -> Int? {
            
            //Swap last element with root and extract original root
            (array[0], array[array.count-1]) = (array[array.count-1], array[0])
            var negate = -1
            if extractMin {negate = 1}
            let root : Int = negate * array.remove(at: array.count-1)
            
            var rootReplacementIndex = 0
            
            var leftChildIndex = rootReplacementIndex*2 + 1
            var rightChildIndex = rootReplacementIndex*2 + 2
            
            //Check for no children, only left child matters because it's balanced
            if leftChildIndex >= array.count {
                return root
            }
            if rightChildIndex >= array.count {
                if array[rootReplacementIndex] > array[leftChildIndex] {
                    (array[rootReplacementIndex], array[leftChildIndex]) = (array[leftChildIndex], array[rootReplacementIndex])
                    return root
                }
                return root
            }
            
            while array[rootReplacementIndex] > array[leftChildIndex] || array[rootReplacementIndex] > array[rightChildIndex] {
                let swapIndex = array[leftChildIndex] < array[rightChildIndex] ? leftChildIndex : rightChildIndex
                
                (array[rootReplacementIndex], array[swapIndex]) = (array[swapIndex], array[rootReplacementIndex])
                
                rootReplacementIndex = swapIndex
                leftChildIndex = rootReplacementIndex*2 + 1
                rightChildIndex = rootReplacementIndex*2 + 2
                
                //Check for no children, only left child matters because it's balanced
                if leftChildIndex >= array.count {
                    return root
                }
                if rightChildIndex >= array.count {
                    if array[rootReplacementIndex] > array[leftChildIndex] {
                        (array[rootReplacementIndex], array[leftChildIndex]) = (array[leftChildIndex], array[rootReplacementIndex])
                        return root
                    }
                    return root
                }
            }
            return root
        }
        
        var i = 0
        while i < array.count {
            if i == 0 || array[i] <= -1 * smallArray[0] {
                insertInt(array[i], intoArray: &smallArray, intoSmallArray: true)
                
            } else {
                insertInt(array[i], intoArray: &bigArray, intoSmallArray: false)
                
            }
            
            //Rebalance array sizes so that the median is always at the top of smallArray
            if smallArray.count - 1 > bigArray.count {
                guard let root = extractRoot(ofArray: &smallArray, extractMin: false) else {print("Error getting root of smallArray"); return -1}
                insertInt(root, intoArray: &bigArray, intoSmallArray: false)
            }
            
            if smallArray.count < bigArray.count {
                guard let root = extractRoot(ofArray: &bigArray, extractMin: true) else {print("Error getting root of bigArray"); return -1}
                insertInt(root, intoArray: &smallArray, intoSmallArray: true)

            }
            medianSum += -1 * smallArray[0]
            
            i += 1
        }
        
        return medianSum % 10000
    }
    
    func arrayFromContentsOfFileWithPath(path: String) -> [Int]? {
        guard var content = try? String(contentsOfFile:path, encoding: .utf8) else {
            return nil
        }
        
        //Clean the file of different newline characters
        content = content.replacingOccurrences(of: "\r", with: "\n")
        content = content.replacingOccurrences(of: "\n\n", with: "\n")
        
        //Breaks text file into an array of strings with each original row as an element in the array, also filters out empty rows
        let vertexStringArray : [String] = content.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        //Takes each element of the vertexStringArray and converts it from a string into an array of Int's then constructs a new array vertexArray of the new arrays (an array of arrays)
        var vertexArray = [Int]()
        for vertexString in vertexStringArray {
            let scanner = Scanner(string: vertexString)
            var value = 0
            while scanner.scanInt(&value) { vertexArray.append(value) }
        }
        
        return vertexArray
        
    }
        
}

