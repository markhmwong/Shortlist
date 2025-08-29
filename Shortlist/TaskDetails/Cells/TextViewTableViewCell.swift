// Custom UITableViewCell with a UITextView for editing text, suitable for the task description row
import UIKit

public protocol TextViewTableViewCellDelegate: AnyObject {
	func textViewCell(_ cell: TextViewTableViewCell, didUpdateText text: String)
}

public class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

	public static let identifier = "TextViewTableViewCell"

	public weak var delegate: TextViewTableViewCellDelegate?

	public weak var tableView: UITableView?

	private let textView: UITextView = {
		let tv = UITextView()
		tv.font = UIFont.preferredFont(forTextStyle: .body)
		tv.isScrollEnabled = false
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = .clear
		tv.textAlignment = .center
		return tv
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(textView)
		NSLayoutConstraint.activate([
			textView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			textView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
			textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
		])
		textView.delegate = self
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		textView.invalidateIntrinsicContentSize()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(title: String, text: String?, tableView: UITableView?) {
		self.tableView = tableView
		textView.text = text ?? ""
	}

	public func textViewDidChange(_ textView: UITextView) {
		delegate?.textViewCell(self, didUpdateText: textView.text)
		DispatchQueue.main.async { [weak self] in
			self?.tableView?.beginUpdates()
			self?.tableView?.endUpdates()
		}
	}
}

