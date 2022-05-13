//
//  HomeViewController.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

class HomeViewController: UIBaseViewController, ViewModelProtocol {
    typealias ViewModel = HomeViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    private let actionRelay = PublishRelay<HomeActionType>()
    private var tapGesture: UITapGestureRecognizer?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        let res = viewModel.transform(req: ViewModel.Input(actionTrigger: actionRelay))
        
        subView.setupDI(relay: actionRelay)
        subView.setupDI(observable: res.isEnable)
    }
    
    // MARK: - View
    let subView = HomeView()
    
    func setupLayout() {
        view.addSubview(subView)
        
        subView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-BaseTabBarController.shared.tabBarHeight)
        }
        
        /// 키보드 나오면, 바깥부분 클릭시 키보드 내리는 옵저버 추가
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] noti in
                guard let `self` = self else { return }
                self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
                self.tapGesture?.cancelsTouchesInView = false
                self.subView.addGestureRecognizer(self.tapGesture!)
            }).disposed(by: rx.disposeBag)
        
        /// 키보드 들어가면, 옵저버 삭제
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] noti in
                guard let `self` = self else { return }
                if self.tapGesture != nil {
                    self.subView.removeGestureRecognizer(self.tapGesture!)
                }
            }).disposed(by: rx.disposeBag)
    }
    
    // MARK: - Methods
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
