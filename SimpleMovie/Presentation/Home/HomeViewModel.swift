//
//  HomeViewModel.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow

enum HomeActionType {
    case rate(String?)
}

class HomeViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    let disposeBag = DisposeBag()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = HomeViewModel
    
    struct Input {
        let actionTrigger: PublishRelay<HomeActionType>
    }
    
    struct Output {
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.actionTrigger.bind(onNext: actionForButton(_:)).disposed(by: disposeBag)
        
        return Output()
    }
    
    func actionForButton(_ type: HomeActionType) {
        switch type {
        case .rate(let text):
            print("TT: \(text ?? "Error")")
            guard let textRate = text else { print("값을 입력해주세요!!!"); return }
            
            if let number = Int(textRate) {
                if number >= 0 && number < 10 {
                    steps.accept(MainSteps.movieList(number))
                } else {
                    print("0~9사이의 값을 입력해주세요!!!!")
                }
            } else {
                print("숫자가 아닙니다...!!")
            }
        }
    }
    
    
    func movieListLoad(limit: Int = 10, _ page: Int = 1, _ minimumRating: Int) {
        _ = NetworkService.movieList(limit: limit, page: page, minimumRating: minimumRating)
            .asObservable()
            .subscribe(onNext: { data in
                
                let tt = (data.pageNumber, data.limit)
                
                print("jhKim : \(tt)")
                
                
                
            }).disposed(by: disposeBag)
        
    }
}
