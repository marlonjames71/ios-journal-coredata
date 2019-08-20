//
//  EntryDetailViewController.swift
//  Journal-CoreData
//
//  Created by Marlon Raskin on 8/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var titleStaticLabel: UILabel!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var bodyStaticLabel: UILabel!
	@IBOutlet weak var bodyTextView: UITextView!
	@IBOutlet weak var gradientView: UIView!
	@IBOutlet weak var bodyView: UIView!

	let layer = CAGradientLayer()
	var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}

	var entry: Entry? {
		didSet {
			updateViews()
		}
	}
	var entryController: EntryController?


    override func viewDidLoad() {
        super.viewDidLoad()
		bodyTextView.delegate = self
		setUpToolBar()
		updateViews()
		setupUI()
	}
    
	@IBAction func saveTapped(_ sender: UIBarButtonItem) {
		guard let title = titleTextField.text,
			let bodyText = bodyTextView.text,
			!title.isEmpty,
			!bodyText.isEmpty else { return }

		if entry == nil {
			entryController?.createEntry(title: title, bodyText: bodyText, identifier: "")
		} else {
			guard let entry = entry else { return }
			entryController?.updateEntry(entry: entry, title: title, bodyText: bodyText, date: Date())
		}
		navigationController?.popViewController(animated: true)
	}


	private func updateViews() {
		guard isViewLoaded else { return }
		titleTextField.text = entry?.title
		bodyTextView.text = entry?.bodyText

		if entry == nil {
			title = "Create Entry"
			dateLabel.isHidden = true
		} else {
			title = entry?.title
			dateLabel.text = "Last modidfied: \(dateFormatter.string(from: entry?.timeStamp ?? Date()))"
		}
	}

	private func setupUI() {
		bodyStaticLabel.isHidden = true
		layer.colors = [UIColor.white.cgColor, UIColor(red: 0.70, green: 0.89, blue: 0.89, alpha: 0.95).cgColor]
		layer.frame = gradientView.bounds
		gradientView.layer.insertSublayer(layer, at: 0)
		bodyView.backgroundColor = .clear
		bodyStaticLabel.isHidden = true
	}

	@objc func doneButtonAction() {
		self.view.endEditing(true)
	}

	private func setUpToolBar() {
		let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
		toolbar.barTintColor = UIColor(red: 0.82, green: 0.83, blue: 0.85, alpha: 1.00)
		let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
		let doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
		doneBtn.tintColor = #colorLiteral(red: 0.05213885743, green: 0.103666974, blue: 0.1644355106, alpha: 1)
		toolbar.setItems([flexSpace, doneBtn], animated: false)
		toolbar.sizeToFit()
		self.titleTextField.inputAccessoryView = toolbar
		self.bodyTextView.inputAccessoryView = toolbar
	}
}

extension EntryDetailViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		UIView.animate(withDuration: 0.3) {
			self.bodyStaticLabel.isHidden = false
			self.bodyView.layer.shadowColor = #colorLiteral(red: 0.05213885743, green: 0.103666974, blue: 0.1644355106, alpha: 1)
			self.bodyView.layer.shadowRadius = 20
			self.bodyView.layer.shadowOpacity = 0.2
			self.bodyView.layer.cornerRadius = 8
			self.bodyView.backgroundColor = .white
		}
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		bodyTextView.layer.borderWidth = 0
		bodyTextView.layer.borderColor = UIColor(red: 0.66, green: 0.85, blue: 0.85, alpha: 1.00).cgColor
		bodyTextView.layer.cornerRadius = 6

		UIView.animate(withDuration: 0.3) {
			self.bodyStaticLabel.isHidden = true
			self.bodyView.backgroundColor = .clear
		}
	}
}
