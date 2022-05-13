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
    override init(naviType: BaseNavigationShowType = .backTitle) {
        super.init(naviType: naviType)
        naviBar.title = "Back"
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
    lazy var movieTitle = UILabel().then {
        $0.font = .notoSans(.bold, size: 19)
        $0.text = "Movie Title"
    }
    
    lazy var rateLabel = UILabel().then {
        $0.text = "평점"
        $0.font = .notoSans(size: 15)
    }
    
    lazy var rate = UILabel().then {
        $0.text = "011"
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        addSubviews([movieTitle, rateLabel, rate])
        movieTitle.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
        }
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitle.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(15)
        }
        rate.snp.makeConstraints {
            $0.top.equalTo(movieTitle.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - SetupDI
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<MovieDetailActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
    
    func setupMovie(data: SampleMovie) {
        self.movieTitle.text = data.movieName
        self.rate.text = "\(data.rate)"
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
