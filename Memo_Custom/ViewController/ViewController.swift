//
//  ViewController.swift
//  Memo_Custom
//
//  Created by Ahn on 2020/05/23.
//  Copyright © 2020 ozofweird. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableRowCount: UILabel!
    
    var content: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //위임
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Cell 연결
        let cellNib = UINib(nibName: "TableCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "TableCell")
        
        // 셀 높이 자동
        tableView.rowHeight = UITableView.automaticDimension
        // 셀 높이 디폴트
        tableView.estimatedRowHeight = 70
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableRowCount.text = String(self.content.count) + " 개의 메모"
        self.tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = self.content[indexPath.row].title
        cell.dateLabel.text = self.content[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = DetailController(nibName: "DetailController", bundle: nil)
        dvc.modalPresentationStyle = .fullScreen
        
        dvc.tempTitle = self.content[indexPath.row].title
        dvc.tempContent = self.content[indexPath.row].content
        dvc.tempRow = indexPath.row

        dvc.detailProtocol = self
        self.present(dvc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.content.remove(at: indexPath.row)
            self.tableRowCount.text = String(self.content.count) + " 개의 메모"
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

extension ViewController: ContentProtocol {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            guard let avc: AddController = segue.destination as? AddController else {
                return
            }
            avc.contentProtocol = self
        }
    }
    
    func addSend(title: String, content: NSAttributedString, date: String) {
        self.content.append(Content(title: title, content: content, date: date))
    }
    
    func detailSend(title: String, content: NSAttributedString, row: Int) {
        self.content[row].title = title
        self.content[row].content = content
    }
    
    
}
