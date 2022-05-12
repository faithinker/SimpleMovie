//
//  MovieDetailViewController.swift
//  SimpleMovie
//
//  Created by pineone on 2022/05/12.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

class MovieDetailViewController: UIBaseViewController, ViewModelProtocol {
    typealias ViewModel = MovieDetailViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    private let actionRelay = PublishRelay<MovieDetailActionType>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
    }
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        _ = viewModel.transform(req: ViewModel.Input(naviBarTrigger: subView.naviBar.navigationAction,
                                                     actionTrigger: actionRelay))
        
        subView
            .setupDI(relay: actionRelay)
    }
    
    // MARK: - View
    let subView = MovieDetailView()
    
    func setupLayout() {
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
}
