//
//  ViewController.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    private let viewModel: UserListViewModelProtocol
    private let disposeBag = DisposeBag()
    private let saveFavorit = PublishRelay<UserListItem>()
    private let deleteFavoriy = PublishRelay<Int>()
    private let fetchMore = PublishRelay<Void>()
    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])

    private let searchTextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.systemGray5.cgColor
        textfield.layer.cornerRadius = 22
        textfield.placeholder = "닉네임을 입력해 주세요"
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textfield.leftView = image
        textfield.leftViewMode = .always
        textfield.tintColor = .systemGray3
        return textfield
    }()
        
    private let tableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "HeaderTableViewCell")
        return tableView
    }()
    
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUI()
        bindView() //구독을 하여 관리
        bindViewModel() //output구현
    }
    
    private func bindView() {
        tabButtonView.selectedType.bind { type in
            print("type: \(type)")
        }.disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        let tabbuttonType = tabButtonView.selectedType.compactMap { $0 } //옵셔널제거
        let query = searchTextField.rx.text.orEmpty.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        let outPut = viewModel.trenform(input: UserListViewModel.Input(tabButtonType: tabbuttonType, query: query, saveFavorite: saveFavorit.asObservable(), deleteFavorite: deleteFavoriy.asObservable(), fetchMore: fetchMore.asObservable()))
                
        outPut.cellData.bind(to: tableView.rx.items) { tableView, index, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") else { return UITableViewCell() }
            (cell as? UserTableViewCell)?.apply(cellData: item)
            
            if let cell = cell as? UserTableViewCell, case let .user(user, isFavorite) = item {
                cell.favoritButton.rx.tap.bind {
                    isFavorite ? self.deleteFavoriy.accept(user.id) : self.saveFavorit.accept(user)
                }.disposed(by: cell.disposeBag) //바인딩을 해제하기 위해. 셀을 다시 그릴때 disposeBag으로 없애야함.
            }
            return cell
        }.disposed(by: disposeBag)
        
        outPut.error.bind { [weak self] ms in
            print(ms)
        }.disposed(by: disposeBag)
    }
    
    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
        view.addSubview(tableView)
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        tabButtonView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

