//
//  UploadSampleViewController.swift
//  StravaSwift_Example
//
//  Created by Tetsuya Kikuchi on 2017/08/30.
//  Copyright © 2017年 Tetsuya Kikuchi. All rights reserved.
//

import UIKit
import StravaSwift

extension StravaClient {
    public var isAuthorized: Bool { return token?.accessToken != nil }
}

extension Date {
    var unixTime: Int { return Int(timeIntervalSince1970) }
}

class UploadSampleViewController: UIViewController {

    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var status: UploadData.Status? {
        didSet {
            print(status?.description ?? "nil")
            statusStackView.isHidden = !StravaClient.sharedInstance.isAuthorized && status != nil
            statusLabel.text = status?.error ?? status?.status
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonStackView.isHidden = !StravaClient.sharedInstance.isAuthorized
        statusStackView.isHidden = !StravaClient.sharedInstance.isAuthorized && status != nil
    }
}

//MARK: - IBAction
extension UploadSampleViewController {

    @IBAction func didTapTCXDataButton(_ sender: UIButton) {
        status = nil
        guard let file = NSDataAsset(name: "tcxUploadSample")?.data else { return }
        
        let tcxData = UploadData(activityType: .ride,
                                 name: "TCX Sample Workout \(Date().unixTime)",
                                 description: nil,
                                 private: true,
                                 trainer: nil,
                                 externalId: Date().unixTime.description,
                                 dataType: .tcx,
                                 file: file)
        upload(tcxData)
    }

    @IBAction func didTapGPXDataButton(_ sender: UIButton) {
        status = nil
        guard let file = NSDataAsset(name: "gpxUploadSample")?.data else { return }

        let gpxData = UploadData(activityType: .ride,
                                 name: "GPX Sample Workout \(Date().unixTime)",
                                 description: nil,
                                 private: true,
                                 trainer: nil,
                                 externalId: Date().unixTime.description,
                                 dataType: .gpx,
                                 file: file)
        upload(gpxData)
    }
    
    @IBAction func didTapReloadStatusButton(_ sender: UIButton) {
        guard let id = status?.id else { return }
        retrieveStatus(id: id)
    }
}

//MARK: - Private Method
extension UploadSampleViewController {
    
    private func upload(_ data: UploadData) {
        
        let router = Router.uploadFile(upload: data)
        StravaClient.sharedInstance.upload(router, upload: data, result: { (status: UploadData.Status?) in
            self.status = status
        }, failure: { error in
            self.statusLabel.text = error.localizedDescription + "(code: \(error.code))"
            debugPrint(error)
        })
    }
    
    private func retrieveStatus(id: Int) {
        
        let router = Router.uploads(id: id)
        try? StravaClient.sharedInstance.request(router, result: { (status: UploadData.Status?) in
            self.status = status
        }, failure: { error in
            self.statusLabel.text = error.localizedDescription + "(code: \(error.code))"
            debugPrint(error)
        })
    }
}
