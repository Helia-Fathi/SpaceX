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
    var viewmodel = LaunchViewModel()
    
    private var photoInteractor: PhotoInteractor?
    var currentIndexPath: IndexPath?
    
    private let missionIcon: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var flightNumber: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minorDetails: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private let successOrFail: UIImageView = {
        var imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.layoutMargins = cellMargins
        contentView.backgroundColor = UIColor(named: "DarkNight")
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        contentView.addSubview(missionIcon)
        contentView.addSubview(successOrFail)
        contentView.addSubview(flightNumber)
        contentView.addSubview(minorDetails)
        contentView.addSubview(launchDate)
        
        NSLayoutConstraint.activate([
            
            missionIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
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
            successOrFail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            successOrFail.widthAnchor.constraint(equalToConstant: 40),
            successOrFail.heightAnchor.constraint(equalToConstant: 40),
            
            launchDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            launchDate.topAnchor.constraint(equalTo: successOrFail.bottomAnchor),
            launchDate.widthAnchor.constraint(equalToConstant: 104),
            launchDate.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        missionIcon.image = nil
        photoInteractor?.cancelDownloading()
        flightNumber.text = nil
        minorDetails.text = nil
        launchDate.text = nil
        successOrFail.image = nil
    }
    
    func configure(with viewModel: MissionCellViewModel) {
        flightNumber.text = viewModel.flightNumber
        minorDetails.text = viewModel.details
        launchDate.text = viewmodel.formatTheDate(from: viewModel.dateUTC!)
        successOrFail.image = viewModel.success ? UIImage(named: "Successed") : UIImage(named: "Failed")
    }
    
    func updateImage(with interactor: PhotoInteractor, for indexPath: IndexPath) {
        self.photoInteractor = interactor
        self.photoInteractor?.downloadPhoto(completion: { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            if let error = error as NSError?, error.code != NSURLErrorCancelled {
                print("Error downloading photo: \(error)")
            } else if let image = image {
                DispatchQueue.main.async {
                    if strongSelf.currentIndexPath == indexPath {
                        strongSelf.missionIcon.image = image
                    }
                }
            }
        })
    }
    
}
