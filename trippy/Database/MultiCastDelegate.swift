//
//  MultiCastDelegate.swift
//  assignment2
//
//  Created by rk on 12/4/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation
class MulticastDelegate<T>{
    private var delegates = Set<WeakObjectWrapper>()
    func addDelegate(_ delegate:T){
        let delegateObject = delegate as AnyObject
        delegates.insert(WeakObjectWrapper(value:delegateObject))
    }
    func removeDelegate(_ delegate:T){
        let delegateObject = delegate as AnyObject
        delegates.remove(WeakObjectWrapper(value:delegateObject))
    }
    func invoke(invocation: (T)-> ()){
        delegates.forEach{(delegateWRapper) in
            if let delegate = delegateWRapper.value{
                invocation(delegate as! T)
            }
        }
    }
}
private class WeakObjectWrapper:Equatable,Hashable{
    weak var value: AnyObject?
    init(value:AnyObject){
        self.value=value
    }
    var hashValue:Int{
        return ObjectIdentifier(value!).hashValue
    }
    static func == (lhs:WeakObjectWrapper,rhs:WeakObjectWrapper)->Bool{
        return lhs.value===rhs.value
    }
}
