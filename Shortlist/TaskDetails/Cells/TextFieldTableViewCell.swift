// Custom UITableViewCell with a UITextField for editing text, suitable for the task name row
import UIKit

protocol TextFieldTableViewCellDelegate: AnyObject {
    func textFieldCell(_ cell: TextFieldTableViewCell, didUpdateText text: String)
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

	public static let identifier = "TextFieldTableViewCell"

    public weak var delegate: TextFieldTableViewCellDelegate?

    private let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .done
		tf.textAlignment = .center
        return tf
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.addSubview(textField)
        NSLayoutConstraint.activate([

            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
			textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 8),
			textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -8),

        ])
        textField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coddscder:) has not been implemented")
    }

	func configure(placeholder: String, text: String?, title: String) {
        textField.placeholder = placeholder
        textField.text = text
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldCell(self, didUpdateText: textField.text ?? "")
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        delegate?.textFieldCell(self, didUpdateText: updatedText)
        return true
    }
}
