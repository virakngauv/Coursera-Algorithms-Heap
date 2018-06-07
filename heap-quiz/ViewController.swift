//
//  ViewController.swift
//  heap-quiz
//
//  Created by Virak Ngauv on 6/7/18.
//  Copyright © 2018 Virak Ngauv. All rights reserved.
//
//  Test answer (sum of medians modulo 10000): 9335
//  Start time: 6/7/18, 3:07pm

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
        //print(computeShortestPaths(ofArray: quizArray))
        medianCruncher(withArray: quizArray)
    }
    
    func medianCruncher (withArray array : [Int]) {
        print(array)
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

