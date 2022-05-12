//
//  MovieListView.swift
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

class MovieListView: UIBasePreviewType {
    
    // MARK: - Model type implemente
    typealias Model = Void
    
    let actionRelay = PublishRelay<MovieListActionType>()
    
    let mock: [SampleMovie] = [
        SampleMovie(movieName: "닥터 스트레인지", rate: 8.8),
        SampleMovie(movieName: "범죄도시2", rate: 9.2),
        SampleMovie(movieName: "민스미트 작전", rate: 5.8),
        SampleMovie(movieName: "봄날", rate: 6.3),
    ]
    
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
    lazy var tableView = UITableView().then {
        $0.rowHeight = 50
    }
    
    // MARK: - Outlets
    
    // MARK: - Methods
    func setupLayout() {
        backgroundColor = .white
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(naviBar.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
    }
    
    // MARK: - SetupDI
    /// User Input
    @discardableResult
    func setupDI(relay: PublishRelay<MovieListActionType>) -> Self {
        actionRelay.bind(to: relay).disposed(by: rx.disposeBag)
        return self
    }
    
    func setupDI(observable: Observable<[Model]>) {
        // model Dependency Injection
    }
    
    func bindData() {
        Observable.just(mock).bind(to: tableView.rx.items) { tableview,
            row, element in
            
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            
            lazy var title: String = element.movieName
            
            lazy var moviTitle = UILabel().then {
                $0.text = title
            }
            
            lazy var rateText: String = "\(element.rate)"
            
            lazy var rate = UILabel().then {
                $0.text = rateText
            }
            
            cell.addSubviews([moviTitle, rate])
            moviTitle.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(15)
            }
            rate.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-15)
            }
            return cell
        }.disposed(by: rx.disposeBag)
    }
}


// MARK: - PreView
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MovieList_Previews: PreviewProvider {
    static var previews: some View {
        //        Group {
        //            ForEach(UIView.previceSupportDevices, id: \.self) { deviceName in
        //                DebugPreviewView {
        //                    return MovieListView()
        //                }.previewDevice(PreviewDevice(rawValue: deviceName))
        //                    .previewDisplayName(deviceName)
        //                    .previewLayout(.sizeThatFits)
        //            }
        //        }        
        Group {
            DebugPreviewView {
                let view = MovieListView()
                //                .then {
                //                    $0.setupDI(observable: Observable.just([]))
                //                }
                return view
            }
        }
    }
}
#endif


struct SampleMovie: Decodable {
    let movieName: String
    let rate: Double
}
