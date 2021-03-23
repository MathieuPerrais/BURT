//
//  AddStoreAppViewController.swift
//  BURT
//
//  Created by Mathieu Perrais on 3/7/21.
//

import UIKit
import SnapKit
import Combine

final class AddStoreAppViewController: UIViewController {
    
    private let repository = AppStoreRepository()
    
    private var networkToken: AnyCancellable?
    private var uiToken: AnyCancellable?
    private var textFieldToken: AnyCancellable?
    
    private let subject = CurrentValueSubject<AppResult?, Never>(nil)

    private let appImagePlaceholderView = UIView()
    private let appImageView = UIImageView()
    private let appNameLabel = UILabel()
    
    private let idField = UITextField()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let addButton = UIButton(type: .roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appInfoContainer = UIView()
        view.addSubview(appInfoContainer)
        appInfoContainer.addSubview(appImageView)
        appInfoContainer.addSubview(appImagePlaceholderView)
        appInfoContainer.addSubview(appNameLabel)
        
        appImageView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(appNameLabel.snp.leading).offset(-20)
            make.width.equalTo(appImageView.snp.height)
        }
        
        appImagePlaceholderView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(appNameLabel.snp.leading).offset(-20)
            make.width.equalTo(appImageView.snp.height)
            make.width.equalTo(appInfoContainer.snp.width).multipliedBy(0.25)
        }
        
        appNameLabel.font = .preferredFont(forTextStyle: .title3)
        appNameLabel.numberOfLines = 3
        appNameLabel.snp.makeConstraints { (make) in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        appInfoContainer.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().inset(20)
        }
        
        appImageView.layer.cornerRadius = 10
        appImageView.clipsToBounds = true
        
        appImagePlaceholderView.layer.cornerRadius = 10
        appImagePlaceholderView.clipsToBounds = true
        appImagePlaceholderView.layoutIfNeeded()
        appImagePlaceholderView.addDashedBorder(color: .lightGray, cornerRadius: 10)
        
        
        let fieldContainer = UIView()
        view.addSubview(fieldContainer)
        fieldContainer.addSubview(idField)
        fieldContainer.addSubview(addButton)

        fieldContainer.snp.makeConstraints { (make) in
            make.top.equalTo(appInfoContainer.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        idField.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(44)
        }

        idField.setContentHuggingPriority(.init(10), for: .horizontal)
        idField.placeholder = "Store ID of the app requested"
        idField.borderStyle = .roundedRect
        idField.keyboardType = .numberPad
        idField.rightView = activityIndicator
        idField.rightViewMode = .always
        idField.becomeFirstResponder()
        
        let publisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: idField)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
        
        textFieldToken = publisher.throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true).sink { [weak self] (output) in
            self?.fetchAppInfo(appId: (output.object as? UITextField)?.text ?? "")
        }
        
        
        addButton.snp.makeConstraints { (make) in
            make.leading.equalTo(idField.snp.trailing).offset(10)
            make.top.bottom.trailing.equalToSuperview()
        }
        addButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        addButton.setTitle("ADD", for: .normal)
        addButton.setImage(UIImage(systemName: "plus.square"), for: .normal)
        
        addButton.addTarget(self, action: #selector(addAppAction), for: .touchUpInside)
        
        
        
        uiToken = subject.receive(on: DispatchQueue.main).sink { [weak self] (appResult) in
            self?.populateUI(appResult: appResult)
        }
        
        populateUI(appResult: nil)
    }
    
    @objc func addAppAction(sender: UIButton!) {
        guard let appResult = subject.value else {
            loggerPersistence.error("Add app button: Can't retrieve the AppResult to store, Publisher value is nil")
            return
        }
        repository.storeAppLookup(result: appResult)
        
        // Thoughts: The UIKit ViewController can still dismiss itself, that's super nice
        // the SwiftUI bool (showView) will be updated (turn back to false) automatically
        // no need to dismiss it with that Boolean from its SwiftUI parent view.
        self.dismiss(animated: true)
    }
    
    
    func fetchAppInfo(appId: String) {
        networkToken?.cancel()
        
        guard let text = idField.text, let appId = Int64(text) else {
            loggerUI.error("App ID input not convertible to Int (current: \(self.idField.text ?? ""))")
            return
        }
        
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        networkToken = repository.fetchAppLookup(id: appId).sink(receiveCompletion: { [weak self] (completion) in
            loggerNetwork.info("fetchAppLookup: completion received")
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }, receiveValue: { [weak self] (response) in
            self?.subject.send(response.body.results.first)
        })
    }
    
    func populateUI(appResult: AppResult?) {
        // Empty case, no result from api, cleaning the UI
        guard let appResult = appResult else {
            self.appImageView.image = nil
            self.appImageView.isHidden = true
            self.appNameLabel.text = "Enter app id"
            self.appNameLabel.textColor = .lightGray
            self.addButton.isEnabled = false
            return
        }
        
        self.appNameLabel.textColor = .darkGray
        self.appNameLabel.text = appResult.name
        self.addButton.isEnabled = true
        self.appImageView.image = nil
        self.appImageView.isHidden = true
        
        DispatchQueue.global(qos: .background).async {
            let image = try? UIImage(data: Data(contentsOf: appResult.icon))

            DispatchQueue.main.async {
                self.appImageView.image = image
                self.appImageView.isHidden = image == nil
            }
        }
    }
}

