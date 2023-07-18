//
//  LaunchDetailsViewController.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/15/23.
//

import Foundation
import UIKit

class LaunchDetailsViewController: UIViewController {
    
    var detailsModel = DetailsViewModel()
    var photoInteractor: PhotoInteractor?
    @Published var details: LaunchDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "DarkNight")
        setupViews()
        setupConstraints()
        wikiLink.isHidden = true
        missionName.text = details?.name
        misionDetails.text = details?.details
        launchDate.text = detailsModel.formatTheDate(from: (details?.dateUTC)!)
    }
    
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
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var misionDetails: UITextView = {
        let text = UITextView()
        text.isUserInteractionEnabled = false
        text.textAlignment = .left
        text.textColor = .white
        text.backgroundColor = UIColor(named: "DarkNight")
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var launchDate: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.textColor = .white
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
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(changeMark), for: .touchUpInside)
        return button
    }()
    
    private let wikiLink: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitle("Check Out on Wiki!", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(visitTheLink), for: .touchUpInside)
        return button
    }()
    
    @objc private func changeMark() {
        guard let flightNumber = details?.name else { return }
        if details?.isMarked == false && isMarked.titleLabel?.text == "Mark It!" {
            detailsModel.saveMissionAsMark(flightNumber: flightNumber)
            isMarked.setTitle("Already Marked!", for: .normal)
        } else {
            detailsModel.deleteMission(flightNumber: flightNumber)
            isMarked.setTitle("Mark It!", for: .normal)
        }
    }
    
    @objc private func visitTheLink() {
        guard let urlString = self.details?.wikiLink, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if details?.wikiLink == nil {
            wikiLink.isHidden = true
        } else {
            wikiLink.isHidden = false
        }
        guard let num = self.details?.name else { return }
        if detailsModel.checkIsMarked(flightNumber: num) {
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
            missionMainImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            missionMainImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            missionMainImage.heightAnchor.constraint(equalToConstant: 240),
            
            missionName.topAnchor.constraint(equalTo: missionMainImage.bottomAnchor, constant: 8),
            missionName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            missionName.heightAnchor.constraint(equalToConstant: 80),
            
            launchDate.topAnchor.constraint(equalTo: missionMainImage.bottomAnchor, constant: 8),
            launchDate.leadingAnchor.constraint(equalTo: missionName.trailingAnchor, constant: 8),
            launchDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            launchDate.widthAnchor.constraint(equalToConstant: 120),
            launchDate.heightAnchor.constraint(equalTo: missionName.heightAnchor),
            
            misionDetails.topAnchor.constraint(equalTo: missionName.bottomAnchor, constant: 8),
            misionDetails.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            misionDetails.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            misionDetails.heightAnchor.constraint(equalToConstant: 200),
            
            wikiLink.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            wikiLink.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            wikiLink.heightAnchor.constraint(equalToConstant: 50),
            wikiLink.bottomAnchor.constraint(equalTo: isMarked.topAnchor, constant: -8),
            
            isMarked.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            isMarked.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            isMarked.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            isMarked.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
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
