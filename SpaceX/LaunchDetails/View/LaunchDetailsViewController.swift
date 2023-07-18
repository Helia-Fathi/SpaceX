//
//  LaunchDetailsViewController.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/15/23.
//

import Foundation
import UIKit

class LaunchDetailsViewController: UIViewController {
    
    var detailsModel = DetailsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        wikiLink.isHidden = true
        missionName.text = details?.name
        misionDetails.text = details?.details
        launchDate.text = details?.dateUTC
        if details?.wikiLink != nil {
            wikiLink.isHidden = false
        }
        
    }
    
    @Published var details: LaunchDetailsViewModel?
    
    private let missionMainImage: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var missionName: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var misionDetails: UITextView = {
        let text = UITextView()
        text.isUserInteractionEnabled = false
        text.textAlignment = .left
        text.textColor = .black
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var launchDate: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.textColor = .black
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isMarked: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.addTarget(self, action: #selector(changeMark), for: .touchUpInside)
        return button
    }()
    
    private let wikiLink: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.addTarget(self, action: #selector(visitTheLink), for: .touchUpInside)
        return button
    }()
    
    @objc private func changeMark() {
        guard let flightNumber = details?.name else {
            return
        }
                
        if details?.isMarked == false && isMarked.titleLabel?.text == "Mark It!"{
            detailsModel.saveMissionAsMark(flightNumber: flightNumber)
            isMarked.setTitle("Already Marked!", for: .normal)
            
        } else {
            detailsModel.deleteMission(flightNumber: flightNumber)
        }
    }

    
    @objc private func visitTheLink() {
        guard let urlString = self.details?.wikiLink, let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("details ine", details)
        guard let num = self.details?.name else { return }
        if detailsModel.checkIsMarked(flightNumber: num ) {
            isMarked.setTitle("Already Marked!", for: .normal)
        } else {
            isMarked.setTitle("Mark It!", for: .normal)
        }
    }

    
    private func setupViews() {
        view.addSubview(missionMainImage)
        view.addSubview(missionName)
        view.addSubview(isMarked)
        view.addSubview(misionDetails)
        view.addSubview(launchDate)
        view.addSubview(wikiLink)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            missionMainImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            missionMainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            missionMainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            missionMainImage.heightAnchor.constraint(equalToConstant: 240),

            missionName.topAnchor.constraint(equalTo: missionMainImage.bottomAnchor, constant: 8),
            missionName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            missionName.heightAnchor.constraint(equalToConstant: 20),

            launchDate.topAnchor.constraint(equalTo: missionMainImage.bottomAnchor, constant: 8),
            launchDate.leadingAnchor.constraint(equalTo: missionName.trailingAnchor, constant: 8),
            launchDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            launchDate.heightAnchor.constraint(equalTo: missionName.heightAnchor),

            misionDetails.topAnchor.constraint(equalTo: missionName.bottomAnchor, constant: 8),
            misionDetails.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            misionDetails.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            misionDetails.bottomAnchor.constraint(equalTo: wikiLink.topAnchor, constant: -8),

            isMarked.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            isMarked.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            isMarked.heightAnchor.constraint(equalToConstant: 50),
            isMarked.widthAnchor.constraint(equalToConstant: view.bounds.width / 2 - 12),

            wikiLink.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            wikiLink.leadingAnchor.constraint(equalTo: isMarked.trailingAnchor, constant: 8),
            wikiLink.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            wikiLink.heightAnchor.constraint(equalToConstant: 50),
            wikiLink.widthAnchor.constraint(equalTo: isMarked.widthAnchor)
        ])
    }
    
        var photoInteractor: PhotoInteractor?
        
    func updateImage(with interactor: PhotoInteractor) {
        self.photoInteractor = interactor
        self.photoInteractor?.downloadPhoto(completion: { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError?, error.code != NSURLErrorCancelled {
                print("Error downloading photo: \(error)")
            } else if let image = image {
                DispatchQueue.main.async {
                    strongSelf.missionMainImage.image = image
                }
            }
        })
    }
}
