//
//  ViewController.swift
//  New York Times App
//
//  Created by Iñigo Alonso on 28/12/21.
//

import UIKit
import Combine

class HomeViewController: BaseViewController<MainCoordinator> {
    
    private let viewModel: HomeViewModel = DefaultHomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var postsView: PostsView = {
        let postsView = PostsView(frame: .zero)
        postsView.translatesAutoresizingMaskIntoConstraints = false
        
        return postsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupView()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

// MARK: - Setup Binding
extension HomeViewController {
    private func setupBinding() {
        
        viewModel.sharedViewModel?.postsModelPublisher
                                  .receive(on: RunLoop.main)
                                  .sink(receiveValue: { model in
                                        guard let model = model else { return }
                                        self.setupPostsView(from: model)
                                  }).store(in: &cancellables)
        
        viewModel.sharedViewModel?.spinnerStatusPublisher
                                  .receive(on: RunLoop.main)
                                  .sink(receiveValue: { status in
                                      guard let status = status else { return }
                                      switch status {
                                          case .start:
                                              self.showSpinner(onView: self.view)
                                          case .stop:
                                              self.removeSpinner()
                                      }
                                  }).store(in: &cancellables)
        

        viewModel.sharedViewModel?.errorPublisher
                                  .receive(on: RunLoop.main)
                                  .sink(receiveValue: { error in
                                      guard let _ = error else { return }
                                      self.showErrorAlert()
                                  }).store(in: &cancellables)
    }
}

// MARK: - Setup View
extension HomeViewController {
    private func setupView() {
        view.addSubview(postsView)
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        DispatchQueue.main.async {
            let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease"), style: .plain, target: self, action: #selector(self.filterButtonTapped))
            self.navigationItem.rightBarButtonItem = filterButton
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            self.navigationController?.navigationBar.backgroundColor = UIColor.colorCatalog(name: .primaryBackground)
            self.title = "New York Times"
        }
    }
    
    private func setupPostsView(from models: [PostsModel]) {
        DispatchQueue.main.async {
            self.postsView.delegate = self
            self.postsView.configureView(from: models)
        }
    }
}

// MARK: - User Actions
extension HomeViewController: PostsViewProtocol {
    @objc private func filterButtonTapped() {
        guard let sharedViewModel = viewModel.sharedViewModel else {
            return
        }
        coordinator?.goToFilterView(sharedViewModel: sharedViewModel)
    }
    
    func postTapped(postModelSelected: PostsModel) {
        guard let sharedViewModel = viewModel.sharedViewModel else {
            return
        }
        sharedViewModel.setPostModelSelected(postModelSelected: postModelSelected)
        coordinator?.goToPostDetailView(sharedViewModel: sharedViewModel)
    }
}

// MARK: - Constraints
extension HomeViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            postsView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            postsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
