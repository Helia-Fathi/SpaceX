//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Helia Fathi on 7/14/23.
//

import Foundation
import UIKit

class LaunchTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: LaunchTableViewCell.self)
    let cellMargins = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    private let missionIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .cyan
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var flightNumber: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.backgroundColor = .red
        label.textColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minorDetails: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.backgroundColor = .green
        label.textColor = .brown
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var launchDate: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.backgroundColor = .purple
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let successOrFail: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let isMarked: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "mark")
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layoutMargins = cellMargins
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubview(isMarked)
        contentView.addSubview(missionIcon)
        contentView.addSubview(successOrFail)
        contentView.addSubview(flightNumber)
        contentView.addSubview(minorDetails)
        contentView.addSubview(launchDate)
        
        NSLayoutConstraint.activate([
            
            isMarked.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            isMarked.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            isMarked.widthAnchor.constraint(equalToConstant: 24),
            isMarked.heightAnchor.constraint(equalToConstant: 16),
            
            missionIcon.leadingAnchor.constraint(equalTo: isMarked.trailingAnchor, constant: 4),
            missionIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            missionIcon.widthAnchor.constraint(equalToConstant: 60),
            missionIcon.heightAnchor.constraint(equalToConstant: 60),
            
            flightNumber.leadingAnchor.constraint(equalTo: missionIcon.trailingAnchor, constant: 16),
            flightNumber.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            flightNumber.widthAnchor.constraint(equalToConstant: 80),
            flightNumber.heightAnchor.constraint(equalToConstant: 24),
            
            minorDetails.topAnchor.constraint(equalTo: flightNumber.bottomAnchor, constant: 8),
            minorDetails.leadingAnchor.constraint(equalTo: missionIcon.trailingAnchor, constant: 16),
            minorDetails.widthAnchor.constraint(equalToConstant: 160),
            minorDetails.heightAnchor.constraint(equalToConstant: 24),
 
            successOrFail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            successOrFail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            successOrFail.widthAnchor.constraint(equalToConstant: 20),
            successOrFail.heightAnchor.constraint(equalToConstant: 20),
            
            launchDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            launchDate.topAnchor.constraint(equalTo: successOrFail.bottomAnchor, constant: 8),
            launchDate.widthAnchor.constraint(equalToConstant: 104),
            launchDate.heightAnchor.constraint(equalToConstant: 24)
        ])
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        missionIcon.image = nil
        flightNumber.text = nil
        minorDetails.text = nil
        launchDate.text = nil
        successOrFail.image = nil
        isMarked.image = nil
    }
    
    func configure(with viewModel: MissionCellViewModel) {
        flightNumber.text = viewModel.flightNumber
        minorDetails.text = viewModel.details
        launchDate.text = viewModel.dateUTC
        successOrFail.image = viewModel.success ? UIImage(named: "success") : UIImage(named: "fail")
        isMarked.isHidden = !viewModel.isMarked
        isMarked.image = viewModel.isMarked ? UIImage(named: "mark") : nil
    }

}
