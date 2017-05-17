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
            guard let item = datasourceItem as? Rank else {
                myRank = nil
                collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                return
            }
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
        cv.backgroundColor = .backgroundGray
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
                cell.datasourceItem = rank
            } else {
                if UserInformation.shared.isAnonymous() {
                    cell.titleLabel.attributedText = getAnonyomousText()
                } else {
                    cell.titleLabel.text = ""
                }
            }
            
        } else {
            cell.backgroundColor = .white
             let attributedText = NSMutableAttributedString()
            
            attributedText.append(NSMutableAttributedString(string: "Lights Catcher ist ein Teilprojekt der Arbeitsgruppe 'Ampel-Assitenz-System' an der Hochschule Augsburg. Die gesammelten Ampelbilder und -daten werden dazu verwendet einen Algorithmus zur Erkennung von Ampelrot und Ampelgrünphasen zu entwickeln. Motivation ist es visuell beeinträchtigten Menschen das Überqueren von Fußgängerampeln zu erleichtern."
, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
            cell.titleLabel.attributedText = attributedText
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
    
    func getAnonyomousText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(NSMutableAttributedString(string: "Hallo Ampeljäger,\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]))
        attributedText.append(NSMutableAttributedString(string: "danke für Deine Unterstützung, um am Ranking teilzunehmen einfach oben rechts\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]))
        attributedText.append(NSMutableAttributedString(string: "Einstellungen -> Logout -> Neuen Account anlegen\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)]))
        
        // Create Paragraph style for lineSpacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = 2
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        
        return attributedText
    }
    
}

class OverviewHeaderDataCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? Rank else {
                return
            }
            
            rank = item
            
            let attributedText = NSMutableAttributedString()
            
                attributedText.append(NSMutableAttributedString(string: "Hallo Ampeljäger ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]))
                attributedText.append(NSMutableAttributedString(string: "\(item.name),\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]))
                attributedText.append(NSMutableAttributedString(string: "danke für Deine Unterstützung, Du hast bis jetzt\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]))
                attributedText.append(NSMutableAttributedString(string: "\(item.points) Punkte ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)]))
            
            // Second line, til date
            attributedText.append(NSMutableAttributedString(string: "gesammelt", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 17)]))
            
            
            // Create Paragraph style for lineSpacing
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.center
            paragraphStyle.lineSpacing = 2
            let range = NSMakeRange(0, attributedText.string.characters.count)
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            
            titleLabel.attributedText = attributedText
        }
    }
    
    var rank: Rank?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
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
        
        titleLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 14, leftConstant: 14, bottomConstant: 14, rightConstant: 14, widthConstant: 0, heightConstant: 0)
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
    
        
        topDividerLineView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 14, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.4)
        
        positionLabel.anchor(topAnchor, left: topDividerLineView.leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        
        nameLabel.anchor(topAnchor, left: positionLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 40, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        pointsLabel.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: 100, heightConstant: 0)
        
    }
    
}

