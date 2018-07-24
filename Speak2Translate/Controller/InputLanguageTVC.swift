//
//  InputLanguageTVC.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import UIKit
import Speech

class InputLanguageTVC: UITableViewController {
    
    //MARK: - Decalare and Initialise Variables and Constants
    var inputLanguages: [Language] = []
    
    //MARK: - Link UI Elements
    //TODO: - Link
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.rowHeight = 80
        
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputLanguages.count
    }
    
    //MARK: - Initialise the input languages
    func load() {
        
        // Get Supported Locales and Set Picker View to Current Locale
        let supportedLocales: Set<Locale> = SFSpeechRecognizer.supportedLocales()
        let currentLocale: Locale = Locale.current
        
        // Loop through supported locales, convert each to a language and append it to the input languages
        for locale in supportedLocales {
            let identifier = locale.identifier
            let localizedString = currentLocale.localizedString(forIdentifier: identifier)
            let language = Language(identifier: identifier, name: localizedString ?? "N/A")
            
            inputLanguages.append(language)
        }
        
        // Sort input languages
        inputLanguages = inputLanguages.sorted()
        
        // Find index of current locale
        let language = Language(identifier: currentLocale.identifier, name: currentLocale.localizedString(forIdentifier: currentLocale.identifier)!)
        let index = inputLanguages.index(of: language)
        
        // Set Table view to current locale
        //TODO: - Select row
        let indexPath: IndexPath = IndexPath(row: index!, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ILTVCCell", for: indexPath)
        
        cell.textLabel?.text = inputLanguages[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToOLTVC" {
            
            let vc = segue.destination as? OutputLanguageTVC
            
            let index = tableView.indexPathForSelectedRow?.row
            
            if let index = index {
                vc?.inputLanguage = inputLanguages[index]
                print("Language passed to OLTVC: \(String(describing: vc?.inputLanguage))")
            }
            
        }
        
    }
    
}
