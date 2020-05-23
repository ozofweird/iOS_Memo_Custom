//
//  DetailController.swift
//  Memo_Custom
//
//  Created by Ahn on 2020/05/23.
//  Copyright © 2020 ozofweird. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var detailTitle: UITextField!
    @IBOutlet weak var detailContent: UITextView!
    
    var detailProtocol: ContentProtocol?
    
    var tempTitle: String?
    var tempContent: NSAttributedString?
    var tempRow: Int?
    
    // 이미지 선택 변수
    let picker = UIImagePickerController()
    
    // 텍스트 뷰 이미지 추가를 위한 변수
    let attributedString = NSMutableAttributedString(string: "")
    let textAttachment = NSTextAttachment()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 데이터 출력
        self.detailTitle.text = tempTitle
        self.detailContent.attributedText = tempContent
        
        // 위임
        self.picker.delegate = self
    }

    func titleAlert(title: String, message: String, text: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okBtn)
        
        return self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func detailBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func detailUploadBtn(_ sender: Any) {
        // detailTitle 필수 입력
        if let title = self.detailTitle.text, !title.isEmpty {
            detailProtocol?.detailSend(title: title, content: self.detailContent.attributedText, row: self.tempRow!)
            dismiss(animated: true, completion: nil)
        } else {
            self.titleAlert(title: "경고", message: "제목을 입력해주세요", text: "확인")
        }
        
    }
    
    @IBAction func detailImageBtn(_ sender: Any) {
        let alert =  UIAlertController(title: "위치 선택", message: "어디서 가져올건가요?", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) { _ in self.openLibrary() }
        let camera =  UIAlertAction(title: "카메라", style: .default) { _ in self.openCamera() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }
}

extension DetailController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        // 시뮬레이터 카메라 에러 예외 처리
        if UIImagePickerController .isSourceTypeAvailable(.camera) {
            self.picker.sourceType = .camera
            self.present(self.picker, animated: false, completion: nil)
        } else {
            print("시뮬레이터 카메라 동작 에러")
        }
    }

    // 이미지 선택 후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.textAttachment.image = image
            self.textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: 15, orientation: .up)
                
            let attrStringWithImage = NSAttributedString(attachment: self.textAttachment)
            attributedString.append(attrStringWithImage)
            attributedString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributedString.length))
            
            self.detailTitle.attributedText = attributedString
//            print("String Test : \(self.contentText.attributedText)")
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
