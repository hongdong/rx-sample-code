//
//  BasicViewModel.swift
//  Stopwatch
//
//  Created by DianQK on 12/09/2016.
//  Copyright © 2016 T. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import RxExtensions

struct BasicViewModel: StopwatchViewModelProtocol {
    
    let startAStopStyle: Observable<Style.Button>
    let resetALapStyle: Observable<Style.Button>
    let displayTime: Observable<String>
    let displayElements: Observable<[(title: Observable<String>, displayTime: Observable<String>, color: Observable<UIColor>)]>
    
    private enum State {
        case timing, stopped
    }
    
    init(input: (startAStopTrigger: Observable<Void>, resetALapTrigger: Observable<Void>)) {
        
        //按钮绑定一个状态
        
        let state = input.startAStopTrigger  //scan可以记录上次状态并进行切换
            .scan(State.stopped) {acum, elem in
                switch acum {
                case .stopped: return State.timing
                case .timing: return State.stopped
                }
            }
            .shareReplay(1)
        
        displayTime = state
            .flatMapLatest { state -> Observable<TimeInterval> in
                switch state {
                case .stopped:
                    return Observable.empty()
                case .timing:
                    return Observable<Int>.interval(0.01, scheduler: MainScheduler.instance).map { _ in 0.01 }
                }
            }
            .scan(0, accumulator: +)
            .startWith(0)
            .map(Tool.convertToTimeInfo)
        
        startAStopStyle = state
            .map { state in
                switch state {
                case .stopped:
                    return Style.Button(title: "Start", titleColor: Tool.Color.green, isEnabled: true, backgroungImage: #imageLiteral(resourceName: "green"))
                case .timing:
                    return Style.Button(title: "Stop", titleColor: Tool.Color.red, isEnabled: true, backgroungImage: #imageLiteral(resourceName: "red"))
                }
        }
        resetALapStyle = Observable.just(Style.Button(title: "不可用", titleColor: UIColor.white, isEnabled: false, backgroungImage: #imageLiteral(resourceName: "gray")))
        displayElements = Observable.empty()
        
    }
}
