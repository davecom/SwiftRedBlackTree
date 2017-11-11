//
//  SwiftRedBlackTree.swift
//  SwiftRedBlackTree
//
//  Copyright (c) 2017 David Kopec
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

// This code was ported from Section 3.3 of Algorithms by Sedgewick & Wayne, 4th Edition
// You can find their Java implementation here:
// https://algs4.cs.princeton.edu/33balanced/RedBlackBST.java.html

public struct RBTree<ValueType: Comparable> {
    // I've read in another Swift implementation of Red Black Trees that
    // unwrapping optionals led to serious performance issues, so I am avoiding
    // that by using a mini-class hierarchy
    private class Node {
        var isRed: Bool {
            if let temp = self as? Full {
                return temp.red
            } else {
                return false
            }
        }
    }
    private class Empty: Node {}
    private class Full: Node {
        var red: Bool // black is false, red is true
        let value: ValueType
        var left: Node
        var right: Node
        init(red: Bool = false, value: ValueType, left: Node = Empty(), right: Node = Empty()) {
            self.red = red
            self.value = value
            self.left = left
            self.right = left
        }
        
        // returns the new link for the parent
        fileprivate func rotateLeft() -> Full {
            guard let right = right as? Full else { return self }
            self.right = right.left
            right.left = self
            right.red = self.red
            self.red = true
            return right
        }
        
        // returns the new link for the parent
        fileprivate func rotateRight() -> Full {
            guard let left = left as? Full else { return self }
            self.left = left.right
            left.right = self
            left.red = self.red
            self.red = true
            return left
        }
        
        fileprivate func flipColors() {
            guard let left = left as? Full, let right = right as? Full else { return }
            self.red = true
            left.red = false
            right.red = false
        }
    }
    
    private var root: Node = Empty()
    
    private mutating func insertHelper(_ v: ValueType, _ current: Node) -> Full {
        guard let temp = current as? Full else {
            return Full(red: true, value: v)
        } // can't deal with empties
        var current = temp
        if v <= current.value {
            current.left = insertHelper(v, current.left)
        } else {
            current.right = insertHelper(v, current.right)
        }
        
        if !current.left.isRed && current.right.isRed {
            current = current.rotateLeft()
        }
        if let left = current.left as? Full, left.red && left.left.isRed {
            current = current.rotateRight()
        }
        if current.left.isRed && current.right.isRed {
            current.flipColors()
        }

        return current
    }
    
    public mutating func insert(_ value: ValueType) {
        root = insertHelper(value, root)
        if let rootEstablished = root as? Full {
            rootEstablished.red = false
        }
    }
    
    public func contains(_ value: ValueType) -> Bool {
        var current = root
        var height = 0
        while let trial = current as? Full {
            height += 1
            if value < trial.value  {
                current = trial.left
            } else if value > trial.value {
                current = trial.right
            } else {
                print("height was \(height)")
                return true
            }
        }
        print("height was \(height)")
        return false
    }
}
