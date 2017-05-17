//
//  SettingsViewController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 05.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView = {
       let tv = UITableView(frame: .zero, style: .grouped)
        return tv
    }()
    
    enum Section: Int {
        case account = 0
        case about = 1

        init(at indexPath: IndexPath) {
            self.init(rawValue: indexPath.section)!
        }
        
        init(_ section: Int) {
            self.init(rawValue: section)!
        }
        
        static let count = 2
        
        var title: String {
            switch self {
            case .account: return "Account"
            case .about: return "Info"
            }
        }
    }

    
    let cellId = "cellId"
    let cellIdDetail = "cellIdDetail"
    
    var tableModel = [Int: [SettingCellData]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        navigationItem.title = "Einstellungen"
        createTableModel()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SettingCellDetail.self, forCellReuseIdentifier: cellIdDetail)
        
        view.addSubview(tableView)
        tableView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func createTableModel() {
        var accountSectionCellData = [SettingCellData]()
        var aboutSectionCellData = [SettingCellData]()
        
        if !UserInformation.shared.isLoggedIn() {
            // Create new account cell
            let createAccountData = SettingCellData(image: nil, key: "Neuen Account erstellen ...", value: nil, action: .createAccount)
            accountSectionCellData.append(createAccountData)
        } else {
            // Create new userName cell
            // Create new logout cell
                let createUserNameData = SettingCellData(image: nil, key: "Username", value: UserInformation.shared.name ?? "", action: .displayOnly)
                accountSectionCellData.append(createUserNameData)
            
            let createLogoutData = SettingCellData(image: nil, key: "Logout", value: nil, action: .logout)
            accountSectionCellData.append(createLogoutData)
        }
        
        let projectInfoData = SettingCellData(image: nil, key: "Datenschutz", value: nil, action: .detailPage)
        aboutSectionCellData.append(projectInfoData)
        
        let termsOfUseDate = SettingCellData(image: nil, key: "Nutzungsbedingungen", value: nil, action: .detailPage)
        aboutSectionCellData.append(termsOfUseDate)
        
        tableModel[Section.account.rawValue] = accountSectionCellData
        tableModel[Section.about.rawValue] = aboutSectionCellData
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableModel.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.account.rawValue {
            return Section.account.title
        } else if section == Section.about.rawValue {
            return Section.about.title
        }
        return "Not found"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = tableModel[section] else { return 0 }
       return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if let data = tableModel[indexPath.section] {
            let cellData = data[indexPath.row]
            
            if let value = cellData.value {
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdDetail, for: indexPath)
                cell?.detailTextLabel?.text = value
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
            }
            
            cell?.textLabel?.text = cellData.key
            
            if cellData.action == .logout {
                cell?.textLabel?.textColor = .red
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let data = tableModel[indexPath.section] {
            let cellData = data[indexPath.row]
            return cellData.action != .displayOnly
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = tableModel[indexPath.section] {
            let cellData = data[indexPath.row]
           
            switch cellData.action {
            case .logout: handleLogout()
                break
            case .createAccount: handleCreateAccount()
                break
            case .detailPage: handleDetailPage(data: cellData)
                break
            default: break
            }
        }
        
        if let iPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: iPath, animated: true)
        }
    }
    
    func handleLogout() {
        UserInformation.shared.logout { (err) in
            if let error = err {
                //TODO errorhandling
                print(error.localizedDescription)
                return
            }
            
            present(LoginViewController(), animated: true) {
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
    
    func handleCreateAccount() {
        print("newAccount")
    }
    
    func handleDetailPage(data: SettingCellData) {
        var htmlUrl: URL?
        
        if data.key == "Datenschutz" {
            htmlUrl = Bundle.main.url(forResource: "datenschutz", withExtension: "html")            
        } else if data.key == "Nutzungsbedingungen" {
            htmlUrl = Bundle.main.url(forResource: "terms_of_use", withExtension: "html")
        }
        
        let urlRequest = URLRequest(url: htmlUrl!)
        
        let wvc = WebViewController()
        wvc.urlRequest = urlRequest
        navigationController?.pushViewController(wvc, animated: true)
    }
}

struct SettingCellData {
    
    enum Action {
        case displayOnly
        case logout
        case createAccount
        case detailPage
    }
    
    var image: UIImage?
    var key: String
    var value: String?
    var action: Action
}

class SettingCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SettingCellDetail: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
