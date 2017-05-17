//
//  RankingViewController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 03.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import LBTAComponents

class RankingViewController: DatasourceController, FIRPersistenceConnectionStateDelegate {
    
    enum Section: Int {
        case overview = 0
        case ranking = 1
        
        init(at indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(_ section: Int) {
            self.init(rawValue: section)!
        }
        
        static let count = 2
        
        var title: String {
            switch self {
            case .overview: return "Overview"
            case .ranking: return "Ranking"
            }
        }
    }
    
    let rankingDatasource = RankingViewDatasource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ConnectionStateManager.shared.connectionStateDelegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Settings-50"), style: .plain, target: self, action:  #selector(handleSettingsBtnPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Help-50"), style: .plain, target: self, action:  #selector(handleHelpBtnPressed))
        navigationItem.title = "🚦LightsCatcher"
        
        collectionView?.backgroundColor = .backgroundGray
        collectionView?.allowsSelection = false
        collectionView?.delegate = self
        
        collectionView?.refreshControl = getRefreshControl()
        collectionView?.refreshControl?.layer.zPosition = -1
        
        if let flow = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.minimumLineSpacing = 0
        }
        
        if !UserInformation.shared.isLoggedIn() {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }

        datasource = rankingDatasource

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserInformation.shared.isLoggedIn() {
            
            if UserDefaults.isFirstLaunch() {
                switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo){
                case .notDetermined:
                    
                    // not yet determined
                    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: nil)
                default: break
                }
                
            }
            
            
            self.fetchRanking()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func connectionState(didChangeTo: ConnectionState) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            if ConnectionStateManager.shared.connectionState == didChangeTo {
                if didChangeTo == .online {
                    UIView.hr_setToastThemeColor(color: .green)
                    self.view.makeToast(message: "Internetverbindung verfügbar", duration: 3, position: HRToastPositionDefault as AnyObject)
                } else if didChangeTo == .offline {
                    UIView.hr_setToastThemeColor(color: .red)
                    self.view.makeToast(message: "Keine Internetverbindung", duration: 6000, position: HRToastPositionDefault as AnyObject)
                }
            }
            
        }
        
    }
    
    func executedOfflineWriteOperation() {
        
    }
    
    func handleLogout() {
        UserInformation.shared.logout { (err) in
            if let error = err {
                //TODO errorhandling
                print(error.localizedDescription)
                return
            }
            
            present(LoginViewController(), animated: true, completion: nil)
        }
    }
    
    func handleSettingsBtnPressed() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func handleHelpBtnPressed() {
        let htmlUrl = Bundle.main.url(forResource: "help", withExtension: "html")
        
        let urlRequest = URLRequest(url: htmlUrl!)
        
        let wvc = WebViewController()
        wvc.urlRequest = urlRequest
        
        navigationController?.pushViewController(wvc, animated: true)
    }
    
    func fetchRanking() {
    
        let usersRef = FIRDatabase.database().reference(withPath: "users")
        usersRef.queryOrdered(byChild: "points").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            var ranks = [Rank]()
            
            for (index, child) in snapshot.children.reversed().enumerated() {
                
                if let snap = child as? FIRDataSnapshot {
                    if let value = snap.value as? NSDictionary {
                        ranks.append(Rank(key: snap.key, dict: value, pos: index + 1))
                    }
                }
                
            }
            
            if let datasource = self.datasource as? RankingViewDatasource {
                datasource.ranking = ranks
                
                if let isRefreshing = self.collectionView?.refreshControl?.isRefreshing {
                    if isRefreshing {
                        self.collectionView?.refreshControl?.endRefreshing()
                    }
                }
                
                self.collectionView?.reloadSections(IndexSet(integer: Section.ranking.rawValue))
            }
        })
        
        if UserInformation.shared.isAnonymous() {
            if let datasource = self.datasource as? RankingViewDatasource {
                datasource.myRank = nil
            }
            self.collectionView?.reloadSections(IndexSet(integer: Section.overview.rawValue))
            return
        }
        
        usersRef.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            UserInformation.shared.setUser(dict: value)
            
            if let datasource = self.datasource as? RankingViewDatasource {
                datasource.myRank = Rank(key: snapshot.key, position: 0, name: UserInformation.shared.name ?? "", points: UserInformation.shared.points ?? 0)
                
                self.collectionView?.reloadSections(IndexSet(integer: Section.overview.rawValue))
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }


    }
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == Section.overview.rawValue {
            return CGSize(width: view.frame.width, height: 200)
        } else if section == Section.ranking.rawValue {
            return CGSize(width: view.frame.width, height: 40)
        }

        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == Section.ranking.rawValue {
            return CGSize(width: view.frame.width, height: 50)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    override func handleRefresh() {
        fetchRanking()
    }

    
}
