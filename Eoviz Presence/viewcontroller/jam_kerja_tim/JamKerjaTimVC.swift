//
//  JamKerjaTimVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 30/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import WebKit
import DIKit
import SVProgressHUD
import RxSwift

class JamKerjaTimVC: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!

    @Inject private var filterJamKerjaTimVM: FilterJamKerjaTimVM
    @Inject private var jamKerjaTimVM: JamKerjaTimVM
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterJamKerjaTimVM.resetFilterJamKerjaTim()
        
        setupView()
        
        observeData()
        
        jamKerjaTimVM.daftarShift(nc: navigationController, data: (dateStart: "", dateEnd: "", listKaryawan: [String]()))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == webview {
            jamKerjaTimVM.isLoading.accept(false)
        }
    }
    
    private func setupView() {
        webview.navigationDelegate = self
    }
    
    private func observeData() {
        jamKerjaTimVM.isLoading.subscribe(onNext: { value in
            if value {
                self.addBlurView(view: self.view)
                SVProgressHUD.show(withStatus: "please_wait".localize())
            } else {
                self.removeBlurView(view: self.view)
                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
        
        jamKerjaTimVM.url.subscribe(onNext: { value in
            let url = URL(string: value)
            guard let _url = url else { return }
            self.webview.load(URLRequest(url: _url))
        }).disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

extension JamKerjaTimVC: FilterJamKerjaTimProtocol {
    func applyFilter(dateStart: String, dateEnd: String, listKaryawan: [String]) {
        jamKerjaTimVM.daftarShift(nc: navigationController, data: (dateStart: dateStart == "" ? "" : PublicFunction.dateStringTo(date: dateStart, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"), dateEnd: dateEnd == "" ? "" : PublicFunction.dateStringTo(date: dateEnd, fromPattern: "dd/MM/yyyy", toPattern: "yyyy-MM-dd"), listKaryawan: listKaryawan))
    }
    
    @IBAction func buttonBackClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        let vc = FilterJamKerjaTimVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
