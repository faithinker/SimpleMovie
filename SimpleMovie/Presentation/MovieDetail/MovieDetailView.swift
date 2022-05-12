//
//  MovieDetailView.swift
//  SimpleMovie
//
//  Created by pineone on 2022/05/12.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MovieDetailView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<MovieDetailActionType>()
    
    // MARK: - init
    override init(naviType: BaseNavigationShowType = .none) {
        super.init(naviType: naviType)
        setupLayout()
        bindData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: - Deinit 개발 완료 한 뒤 메모리가 정상적으로 해제 되면 삭제!
    deinit {
        Log.d("로그 : \(self)!!")
    }
    
    // MARK: - View
    lazy var label = UILabel().then {
        $0.text = "MovieDetail View"
        $0.textColor = .red
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - SetupDI
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<MovieDetailActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
    
    func setupDI(observable: Observable<[Model]>) {
        // model Dependency Injection
    }
    
    func bindData() {
        // d
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return MovieDetailView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = MovieDetailView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif
