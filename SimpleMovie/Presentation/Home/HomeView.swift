//
//  HomeView.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class HomeView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<HomeActionType>()
    
    // MARK: - init
    override init(naviType: BaseNavigationShowType = .centerTitle) {
        super.init(naviType: naviType)
        naviBar.title = "movie"
        setupLayout()
        bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    lazy var descriptionLabel = UILabel().then {
        $0.text = "최소 평점을 입력하세요 (0~9)"
        $0.font = .notoSans(size: 15)
    }
    
    lazy var textfield = UITextField().then {
        $0.placeholder = "(0~9)"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .numberPad
        $0.returnKeyType = .done
    }
    
    lazy var nextButton = UIButton().then {
        $0.backgroundColor = .systemBlue ~ 50%
        $0.setTitle("다음", for: .normal)
        $0.rx.tap
            .map { [weak self] in
                guard let `self` = self else { return .rate(nil) }
                return .rate(self.textfield.text)
            }
            .bind(to: actionRelay)
            .disposed(by: rx.disposeBag)
            
    }
    
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        
        addSubviews([descriptionLabel, textfield, nextButton])
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
        }
        
        textfield.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(15)
        }

        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(35)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
    func bindData() {
        textfield.rx.observe(String.self, "text")
            .subscribe(onNext: {
                print("Ob Text: \($0 ?? "Error")")
            }).disposed(by: rx.disposeBag)
    }
    
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<HomeActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
}

// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return HomeView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = HomeView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
