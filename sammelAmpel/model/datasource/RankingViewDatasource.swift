//
//  RankingViewDatasource.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 05.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import LBTAComponents

class RankingViewDatasource: Datasource {
    
    typealias Sections = RankingViewController.Section
    var ranking: [Rank]?
    var myRank: Rank?
    
    override init() {
        super.init()
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [OverviewHeaderCell.self, RankingHeaderCell.self]
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [RankingCell.self]
    }
    
    override func numberOfSections() -> Int {
        return Sections.count
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        if section == Sections.ranking.rawValue {
            return ranking?.count ?? 5
        }
        
        return 0
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == Sections.ranking.rawValue {
            guard let rank = ranking?[indexPath.item] else { return nil }
            return rank
        }
        return nil
    }
    
    override func headerItem(_ section: Int) -> Any? {
        if section == Sections.overview.rawValue {
            return myRank ?? nil
        } else if section == Sections.ranking.rawValue {
            return Sections.ranking.title
        }
        
        return nil
    }
    
}
