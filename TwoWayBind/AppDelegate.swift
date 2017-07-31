//
//  AppDelegate.swift
//
//  Created by Abner on 8/24/16.
//  Copyright © 2017 T. All rights reserved.
//  http://www.abnerh.com

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        test()
    }
    
    func test() {
        do{
            
            let dealed_arr = [1,2,3,4,5,6]
                            .filter{
                                return $0 % 2 == 0
                            }.map{
                                return $0 * 2
                            }
            
            print(dealed_arr)
            
        } //test1
        
        do{
            
            let dealed_arr = [1,2,3,4,5,6]
                .filter({
                    return $0%2 == 0
                }).map({
                    return $0 * 2
                })
            
            print(dealed_arr)
            
        } //test2
        
        do{
            let what = [1,2,3,4,5,6].filter
            print(what)
        } //test3  ((Int) -> Bool) -> [Int]
    }

}
