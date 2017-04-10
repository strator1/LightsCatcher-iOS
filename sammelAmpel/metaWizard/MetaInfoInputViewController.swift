//
//  MetaInfoInputViewController.swift
//  sammelAmpel
//
//  Created by Patrick Valenta on 04.04.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit
import Firebase

class MetaInfoInputViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var backButton: UIView = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true

        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.4
        
        btn.setImage(#imageLiteral(resourceName: "Back Filled-50"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        btn.isEnabled = true
        btn.alpha = 1.0
        
        return btn
        
    }()
    
    lazy var undoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.4
        
        btn.backgroundColor = .white
         btn.setImage(#imageLiteral(resourceName: "Undo Filled-50"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(undoBtnPressed), for: .touchUpInside)
        btn.isEnabled = false
        btn.alpha = 0.4
        
        return btn
        
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.4
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitle("Bild hochladen", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(sendBtnPressed), for: .touchUpInside)
        btn.isEnabled = true
        btn.alpha = 1.0
        
        return btn
    }()
    
    lazy var helpButton: UIView = {
        let btn = UIButton(type: UIButtonType.infoLight)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 0.4
        
//        btn.setImage(#imageLiteral(resourceName: "Back Filled-50"), for: .normal)
        btn.tintColor = .black
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addTarget(self, action: #selector(helpBtnPressed), for: .touchUpInside)
        btn.isEnabled = true
        btn.alpha = 1.0
        
        return btn
        
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    let titleLabel: UILabel = {
       let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.adjustsFontSizeToFitWidth = true
        l.text = "Test"
        return l
    }()
    
    var bivGestureRecognizer: UIGestureRecognizer?
    var touchLocation = CGPoint()
    var pickedNodes = [LightPosition]()
    var insertedNodes = [LightPosition]() {
        didSet {
            if insertedNodes.count > 0 {
                undoButton.isEnabled = true
                undoButton.alpha = 1.0
            } else {
                undoButton.isEnabled = false
                undoButton.alpha = 0.4
            }
            
            photoInformation?.lightCount = insertedNodes.count
        }
    }
    
    var photoInformation: PhotoInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .red
        setupViews()
    }
    
    func setupViews() {
        
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 00, widthConstant: 0, heightConstant: 0)
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(undoButton)
        undoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        undoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(titleLabel)
        titleLabel.anchor(view.topAnchor, left: backButton.rightAnchor, bottom: nil, right: undoButton.leftAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 48)

        view.addSubview(helpButton)
        helpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        helpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        helpButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        helpButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        sendButton.leftAnchor.constraint(equalTo: helpButton.rightAnchor, constant: 12).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        bivGestureRecognizer = UIGestureRecognizer()
        bivGestureRecognizer?.delegate = self
        
        let rec = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(rec)
        
        backgroundImageView.addGestureRecognizer(bivGestureRecognizer!)
    
        setTitleText()
        
    }
    
    func setTitleText() {
        let attributes = [NSForegroundColorAttributeName: UIColor.white, NSStrokeWidthAttributeName: -2, NSStrokeColorAttributeName: UIColor.black] as [String : Any]
        titleLabel.attributedText = NSAttributedString(string: "🚦 markieren", attributes: attributes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.isFirstAmpelCapture() {
            helpBtnPressed()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        guard let image = photoInformation?.image else { return }
        
        backgroundImageView.image = image
        print("set")
    }
    
    @objc private func backBtnPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func helpBtnPressed() {
        let alertController = UIAlertController(title: "Erste Hilfe", message: "Markiere per Tap auf den Bildschirm alle Ampeln, die auf dem Bild zu sehen sind.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Verstanden 👌", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func sendBtnPressed() {
        photoInformation?.lights = insertedNodes
        
        if let image = photoInformation?.image {
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("lights_images").child("\(imageName).jpg")
            
            if let uploadData = UIImageJPEGRepresentation(image, 0.4) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let imageUrl = metadata?.downloadURL()?.absoluteString {

                        let key = NSUUID().uuidString
                        var user = String()
                        var lightsArray = [String: Any]()
                        var lightsCount = 0
                        var gyroPosition = String()
                        var latitude = String()
                        var longitude = String()
                        let createdAt = Date().millisecondsSince1970
                        
                        if let currentUser = FIRAuth.auth()?.currentUser {
                            user = currentUser.uid
                        }
                        
                        if let count = self.photoInformation?.lightCount {
                            lightsCount = count
                        }
                        
                        if let pos = self.photoInformation?.gyroPosition {
                            gyroPosition = String(pos)
                        }

                        if let lat = self.photoInformation?.latitude {
                            latitude = lat.description
                        }
                        
                        if let lon = self.photoInformation?.longitude {
                            longitude = lon.description
                        }
                        
                        if let lights = self.photoInformation?.lights {
                            for (index, light) in lights.enumerated() {
                                guard let x = light.x, let y = light.y, let phase = light.phase else { continue }
                                var lightsDict = [String: Any]()
                                lightsDict["x"] = x
                                lightsDict["y"] = y
                                lightsDict["phase"] = phase.rawValue
                                lightsArray[index.description] = lightsDict
                            }
                        }
                        
                        let productDict = ["user": user, "imageUrl": imageUrl, "lightsCount": lightsCount, "lightPositions": lightsArray, "gyroPosition": gyroPosition, "latitude": latitude, "longitude": longitude, "createdAt": "\(createdAt)"] as [String: Any]
                        
                        
                        self.saveDataIntoDatabaseWith(uid: key, values: productDict)
                        
                    }
                    
                })
            }
            
            
        }

    }
    
    func saveDataIntoDatabaseWith(uid: String, values: [String: Any]) {
        //Saving user to database
        let ref = FIRDatabase.database().reference()
        
        var childUpdates = ["/lights/\(uid)": values]
        
        if let userDict = UserInformation.shared.getUserDictionary(addToPoints: 1) {
            childUpdates["/users/\(UserInformation.shared.getUid() ?? "")"] = userDict
        }
        
        ref.updateChildValues(childUpdates) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            
            print("Saved product successfully into Firebase db")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc fileprivate func undoBtnPressed() {
        guard let pos = insertedNodes.last else { return }
        print(insertedNodes.count)
        pos.view.removeFromSuperview()
        insertedNodes.remove(at: insertedNodes.count - 1)
        print(insertedNodes.count)
    }
    
}

extension MetaInfoInputViewController: UIGestureRecognizerDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: backgroundImageView)
            
            pickedNodes = getNodes(atLocation: touchLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //move node(s)
        for touch in touches {
            touchLocation = touch.location(in: backgroundImageView)
            
            for node in pickedNodes {
                node.setPos(atPoint: touchLocation)
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //drop node(s)
        pickedNodes = [LightPosition]()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func createView(atLocation location: CGPoint) {
        if insertedNodes.count <= 2 {
            let newView = UIView()
            newView.backgroundColor = .red
            
            let rec = UITapGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
            newView.addGestureRecognizer(rec)
            
            let frame = CGRect(origin: location, size: CGSize(width: 30, height: 30))
            newView.frame = frame
            
            view.addSubview(newView)
            view.layoutIfNeeded()
        
            let pos = LightPosition(view: newView)
            pos.setPos(atPoint: location)
            insertedNodes.append(pos)
            
            showLightPhaseActionSheet(newPos: pos, isNew: true)
            
        }
    }
    
    func onLongPress(_ sender: UILongPressGestureRecognizer) {
        for pos in insertedNodes {
            if pos.view == sender.view {
                showLightPhaseActionSheet(newPos: pos, isNew: false)
                break
            }
        }
    }
    
    func onTap(_ rec: UIGestureRecognizer) {
        if rec.numberOfTouches > 0 {
            let loc = rec.location(ofTouch: 0, in: backgroundImageView)
            
            if getNodes(atLocation: loc).count == 0 {
                createView(atLocation: loc)
            }
        }
    }
    
    func showLightPhaseActionSheet(newPos: LightPosition, isNew: Bool) {
        let alertController = UIAlertController(title: "🚦", message: "Rot oder Grünphase?", preferredStyle: .actionSheet)
        
        let redPhaseButton = UIAlertAction(title: "Rot", style: .default, handler: { (action) -> Void in
            newPos.view.backgroundColor = .red
            newPos.phase = .red
        })
        
        let greenPhaseButton = UIAlertAction(title: "Grün", style: .default, handler: { (action) -> Void in
            newPos.view.backgroundColor = .green
            newPos.phase = .green
        })
        
        let canelButton = UIAlertAction(title: "Abbrechen", style: .cancel, handler: { (action) -> Void in
            if isNew {
                self.undoBtnPressed()
            }
        })
        
        let deleteButton = UIAlertAction(title: "Löschen", style: .destructive, handler: { (action) -> Void in
            let index = self.insertedNodes.index(where: { $0 === newPos })
            if index != nil {
                newPos.view.removeFromSuperview()
                self.insertedNodes.remove(at: index!)
            }
        })

        
        alertController.addAction(redPhaseButton)
        alertController.addAction(greenPhaseButton)
        alertController.addAction(canelButton)
        
        if !isNew {
          alertController.addAction(deleteButton)
        }
        
        
        present(alertController, animated: true, completion: nil)

    }
    
    func getNodes(atLocation point: CGPoint) -> [LightPosition] {
        var nodes = [LightPosition]()
        
        for node in insertedNodes {
            if node.view.frame.contains(point) {
                nodes.append(node)
            }
        }
        
        return nodes
    }
    
}

class LightPosition {
    var view: UIView
    var phase: PhotoInformation.LightPhase?
    var x: CGFloat?
    var y: CGFloat?
    
    init(view: UIView) {
        self.view = view
    }
    
    func setPos(atPoint point: CGPoint) {
        self.view.frame.origin.x = point.x - self.view.frame.width/2
        self.view.frame.origin.y = point.y - self.view.frame.height/2
        
        self.x = point.x
        self.y = point.y
    }
}


