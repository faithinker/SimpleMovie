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
    
    var isButtonEnable = PublishRelay<Bool>()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = HomeViewModel
    
    struct Input {
        let actionTrigger: PublishRelay<HomeActionType>
    }
    
    struct Output {
        let isEnable: Observable<Bool>
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.actionTrigger.bind(onNext: actionForButton(_:)).disposed(by: disposeBag)
        
        return Output(isEnable: isButtonEnable.asObservable())
    }
    
    func actionForButton(_ type: HomeActionType) {
        switch type {
        case .rate(let text):
            print("TT: \(text ?? "Error")")
            guard let textRate = text else { print("값을 입력해주세요!!!"); return }
            
            if let number = Int(textRate) {
                if number >= 0 && number < 10 {
                    self.isButtonEnable.accept(false)
                    self.movieListLoad(minimumRating: number)
                } else {
                    print("0~9사이의 값을 입력해주세요!!!!")
                }
            } else {
                print("숫자가 아닙니다...!!")
            }
        }
    }
    
    /// API 찌르는것을 MovieListViewModel에서 시도했으나..
    /// 데이터 로드가 오래 걸려 홈화면에서 Response값 받아서 전송함...
    func movieListLoad(limit: Int = 10, page: Int = 1, minimumRating: Int) {
        _ = NetworkService.movieList(limit: limit, page: page, minimumRating: minimumRating)
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let `self` = self else { return }
                self.isButtonEnable.accept(true)
                self.steps.accept(MainSteps.movieList(data.movieList))
            }).disposed(by: disposeBag)
    }
}
