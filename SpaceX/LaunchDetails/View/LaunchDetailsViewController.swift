//
//  LaunchDetailsViewController.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/15/23.
//

import Foundation
import UIKit

class LaunchDetailsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()

    }
    
    private let missionMainImage: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .cyan
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var missionName: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var misionDetails: UITextView = {
        let text = UITextView()
        text.isUserInteractionEnabled = false
        text.textAlignment = .left
        text.backgroundColor = .green
        text.textColor = .brown
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var launchDate: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.backgroundColor = .green
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let isMarked: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let wikiLink: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
            missionMainImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            missionMainImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            missionMainImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            missionName.topAnchor.constraint(equalTo: missionMainImage.bottomAnchor, constant: 8),
            missionName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            isMarked.topAnchor.constraint(equalTo: missionMainImage.bottomAnchor, constant: 8),
            isMarked.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            misionDetails.topAnchor.constraint(equalTo: missionName.bottomAnchor, constant: 8),
            misionDetails.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            misionDetails.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            launchDate.topAnchor.constraint(equalTo: misionDetails.bottomAnchor, constant: 8),
            launchDate.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            launchDate.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            wikiLink.topAnchor.constraint(equalTo: launchDate.bottomAnchor, constant: 8),
            wikiLink.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            wikiLink.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            wikiLink.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}
