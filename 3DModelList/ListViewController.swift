//
//  ListViewController.swift
//  3DModelList
//
//  Created by Jakub Iwaszek on 01/06/2021.
//

import UIKit
import NVActivityIndicatorView

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var elements: [TDModel] = []
    var blurViewEffect: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getElementsData()
    }
    
    func getElementsData() {
        let loaderView = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse, color: .blue, padding: nil)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        blurViewEffect.frame = self.view.bounds
        view.addSubview(blurViewEffect)
        view.addSubview(loaderView)
        NSLayoutConstraint.activate([
            loaderView.widthAnchor.constraint(equalToConstant: 50),
            loaderView.heightAnchor.constraint(equalToConstant: 50),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loaderView.startAnimating()
        FirebaseStorage.shared.getListedElements { (elements) in
            self.blurViewEffect.removeFromSuperview()
            loaderView.stopAnimating()
            self.elements = elements
            self.tableView.reloadData()
        }
    }

}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.model = elements[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chosenElement = elements[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "SceneViewController") as! ViewController
        vc.element = chosenElement
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
