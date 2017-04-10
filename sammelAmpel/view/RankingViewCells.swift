//
//  RankingViewCells.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 05.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import LBTAComponents

class OverviewHeaderCell: DatasourceCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? Rank else { return }
            myRank = item
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
    }
    
    var myRank: Rank?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .purple
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    let pageControl: UIPageControl = {
       let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .red
        pc.numberOfPages = 2
        return pc
    }()
    
    let cellId = "cellId"
    
    let bottomDividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .yellow
        
        addSubview(collectionView)
        addSubview(bottomDividerLineView)
        addSubview(pageControl)
        
        collectionView.register(OverviewHeaderDataCell.self, forCellWithReuseIdentifier: cellId)
        
        pageControl.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        collectionView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        bottomDividerLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.4)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OverviewHeaderDataCell
        
        if indexPath.item == 0 {
            cell.backgroundColor = .white
            
            if let rank = myRank {
             cell.titleLabel.text = rank.name + ", \(rank.points) Points"
            }
            
        } else {
            cell.backgroundColor = .white
            cell.titleLabel.text = "Projekt- + Challengeinformationen"
        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / frame.width)
        
        if pageNumber == 0 {
            pageControl.currentPageIndicatorTintColor = .red
        } else if pageNumber == 1 {
            pageControl.currentPageIndicatorTintColor = .green
        }
        pageControl.currentPage = pageNumber
    }
    
}

class OverviewHeaderDataCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? String else { return }
            titleLabel.text = item
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let bottomDividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .green
        
        addSubview(titleLabel)
        addSubview(bottomDividerLineView)
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomDividerLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.4)
        
    }
    
}

class RankingHeaderCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? String else { return }
            titleLabel.text = item.uppercased()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SectionTitle"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let bottomDividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .clear
        
        addSubview(titleLabel)
        addSubview(bottomDividerLineView)
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 14, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomDividerLineView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.4)
        
    }
    
}

class RankingCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            if let item = datasourceItem as? Rank {
                self.rank = item
                nameLabel.text = item.name
                positionLabel.text = item.getPositionText()
                pointsLabel.text = "\(item.points.description) Punkte"

                topDividerLineView.isHidden = item.position == 1 ? true : false
            }
        }
    }
    
    var rank: Rank?
    
    let notificationImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Settings-50"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 18)
        
        return label
    }()
    
    let topDividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                nameLabel.textColor = .white
                backgroundColor = UIView.appearance().tintColor
            } else {
                nameLabel.textColor = .black
                backgroundColor = .white
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        addSubview(topDividerLineView)
        addSubview(positionLabel)
        addSubview(nameLabel)
        addSubview(pointsLabel)
        
//        positionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
//        positionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
//        positionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        positionLabel.widthAnchor.constraint(equalTo: positionLabel.heightAnchor, constant: 0).isActive = true
        
        topDividerLineView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.4)
        
        positionLabel.anchor(topAnchor, left: topDividerLineView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        
        nameLabel.anchor(topAnchor, left: positionLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        pointsLabel.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 100, heightConstant: 0)
        
    }
    
}

