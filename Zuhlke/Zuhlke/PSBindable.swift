//
//  PSBindable.swift
//  Zuhlke
//
//  Created by #HellRaiser on 21/08/20.
//  Copyright © 2020 asharpvan. All rights reserved.
//

import Foundation

protocol PSBindableProtocol {
    associatedtype ListenerCallback
    associatedtype ValueType
    
    var value : ValueType { get set }
    
    func bind(listener: ListenerCallback)
    func bindAndFireEvent(listener: ListenerCallback)
    func fireEvent()
}

class PSBindable<T> : NSObject, PSBindableProtocol {
    
    typealias ListenerCallback = (T) -> ()
    typealias ValueType = T
    
    private var listener : ListenerCallback?
    
    var value: ValueType {
        didSet {
            fireEvent()
        }
    }
    
    init(_ value: ValueType) {
        self.value = value
    }
    
    func bind(listener: @escaping ListenerCallback) {
        self.listener = listener
    }
    
    func bindAndFireEvent(listener: @escaping ListenerCallback) {
        bind(listener: listener)
        listener(value)
    }
    
    func fireEvent() {
        listener?(self.value)
    }
}
