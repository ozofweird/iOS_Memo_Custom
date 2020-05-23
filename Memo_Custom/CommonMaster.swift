//
//  CommonMaster.swift
//  Memo_Custom
//
//  Created by Ahn on 2020/05/23.
//  Copyright © 2020 ozofweird. All rights reserved.
//

import Foundation

struct Content {
    var title: String
    var content: NSAttributedString
    var date: String
    
    init(title: String, content: NSAttributedString, date: String) {
        self.title = title
        self.content = content
        self.date = date
    }
}

protocol ContentProtocol {
    func addSend(title: String, content: NSAttributedString, date: String)
    func detailSend(title: String, content: NSAttributedString, row: Int)
}

