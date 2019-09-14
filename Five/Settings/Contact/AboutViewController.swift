//
//  ContactViewController.swift
//  Five
//
//  Created by Mark Wong on 7/9/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    lazy var contact: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSelectable = false
        view.isEditable = false
        return view
    }()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private let appName = AppMetaData.name
    
    private let appVersion = AppMetaData.version
    
    private let appBuild = AppMetaData.build
    
    lazy var details = """
    Thanks for using \(appName) v\(appVersion ?? " unknown"), build \(appBuild ?? "unknown").\n
    \n
    "sense of finality", less overwhelmed, overcome procrastination, building a sense of accomplishment
    There's are many ToDo/Task list applications, including Apple's Reminder App. Ever since the advent of mobile devices holding large capacities, applications have exploited this generous feature. I believe we've taken this for granted, progressively made us harder to focus, overwhelmed and less motivated to finish our work.
    
    As I'm typing this I just recalled the day I received my first electronic address book device. That thing advertised x amount address book and reminders it could store as it's leading feature.\n
    
    I guess this is where I'm taking this application back to, when times were simpler, and things were limited.\n
    
    If you're an avid and master at productivity, this app may not be for you, but I encourage you to take a look at your own reminder list and look at the tasks that are lingering from the week/month/year before. It certainly would leave a guilty feeling inside as the task slowly fades far into the past. This app intends to remove and notion of revisitng old tasks, keep track of incomplete tasks and completed tasks and remind you to keep your goal small and focused for the day.\n
    
    We would rather see 5/5 rather than 5/10 right? It's not only encouraging but motivating, especially for those who struggle to find focus and narrow their field of vision (so to speak). Lingering tasks will always be left in the attic collecting dust, and dusting it off only sets us back. Do what you can and only do that for the day to finish on a high note and continue tomorrow.\n
    
    Privacy.\n
    To be completed. May use Google Analytics to monitor app usage
    
    Bugs.\n
    Please report any bugs to hello@whizbangapps.xyz.
    
    Contact.\n
    Twitter: @markhmwong\nWebsite: https://www.whizbangapps.xyz/\(appName)
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        contact.attributedText = NSAttributedString(string: "\(details)", attributes: [NSAttributedString.Key.foregroundColor : Theme.Font.Color, NSAttributedString.Key.font: UIFont(name: Theme.Font.Regular, size: Theme.Font.FontSize.Standard(.b3).value)!])
        view.addSubview(contact)
        contact.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
    }
    
    @objc
    func handleBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
