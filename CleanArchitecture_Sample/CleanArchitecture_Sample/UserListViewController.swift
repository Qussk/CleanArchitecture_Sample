//
//  ViewController.swift
//  CleanArchitecture_Sample
//
//  Created by 변윤나 on 12/18/24.
//

import UIKit

class UserListViewController: UIViewController {
   private let viewModel: UserListViewModelProtocol
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .yellow
    }

    required init?(coder: NSCoder) {
        fatalError("error")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

