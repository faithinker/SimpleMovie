//
//  MovieListViewModel.swift
//  SimpleMovie
//
//  Created by pineone on 2022/05/12.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import Action

enum MovieListActionType {
    case detailMovie(Movie)
}

class MovieListViewModel: ViewModelType, Stepper {
    // MARK: - Stepper
    var steps = PublishRelay<Step>()
    
    // MARK: - ViewModelType Protocol
    typealias ViewModel = MovieListViewModel
    
    var disposeBag = DisposeBag()
    
    var movieList: BehaviorRelay<[Movie]>
    
    init(list: [Movie]) {
        movieList = BehaviorRelay<[Movie]>(value: list)
    }
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - Actions
    lazy var actionForNaviBar = Action<BaseNavigationActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .back:
            self.steps.accept(MainSteps.popViewController)
        default: break
        }
        return .empty()
    }
    
    lazy var actionForButton = Action<MovieListActionType, Void> { [weak self] in
        guard let `self` = self else { return .empty() }
        switch $0 {
        case .detailMovie(let item):
            self.steps.accept(MainSteps.movieDetail(item))
        }
        return .empty()
    }
    
    struct Input {
        let naviBarTrigger: PublishRelay<BaseNavigationActionType>
        let actionTrigger: PublishRelay<MovieListActionType>
    }
    
    struct Output {
        let movieList: Observable<[Movie]>
    }
    
    func transform(req: ViewModel.Input) -> ViewModel.Output {
        req.naviBarTrigger.bind(to: actionForNaviBar.inputs).disposed(by: disposeBag)
        req.actionTrigger.bind(to: actionForButton.inputs).disposed(by: disposeBag)
        return Output(movieList: movieList.asObservable())
    }
    
    // 이미 ViewDidLoad 된 다음에 API를 요청하기 때문에 사용자가 빈화면을 보게된다!! 그래서 사용하지 않는다!
    func movieListLoad(limit: Int = 10, page: Int = 1, minimumRating: Int) {
        _ = NetworkService.movieList(limit: limit, page: page, minimumRating: minimumRating)
            .asObservable()
            .subscribe(onNext: { [weak self] data in
                guard let `self` = self else { return }
                self.movieList.accept(data.movieList)
                print("jhKim : \(data)")
            }).disposed(by: disposeBag)
    }
    
}
