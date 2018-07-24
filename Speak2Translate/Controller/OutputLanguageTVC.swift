//
//  OutputLanguageTVC.swift
//  Speak2Translate
//
//  Created by Arjun Singh on 24/07/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import UIKit

class OutputLanguageTVC: UITableViewController {
    
    var inputLanguage: Language = Language(identifier: "N/A", name: "N/A")
    var outputLanguages: [Language] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        load()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return outputLanguages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OLTVCCell", for: indexPath)
        
        cell.textLabel?.text = outputLanguages[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Use Tanslator to load output languages
    
    func load() {
        let target = inputLanguage.identifier.removeCountryCode()
        
        Translator.requestSupportedLanguages(forTarget: target) { (isSuccessful, response) in
            
            if isSuccessful {
                self.outputLanguages = response
            } else {
                self.outputLanguages = [Language(identifier: "Error", name: "Error requesting output languages")]
                print("Error requesting output languages")
            }
            
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToS2TVC" {
            
            let vc = segue.destination as? S2TVC
            
            vc?.inputLanguage = self.inputLanguage
            
            let index = tableView.indexPathForSelectedRow?.row
            
            if let index = index {
                vc?.outputLanguage = outputLanguages[index]
                
                print("Input Language passed from OLVC to S2TSVC: \(String(describing: vc?.inputLanguage))")
                print("Output Language passed from OLVC to S2TSVC: \(String(describing: vc?.outputLanguage))")
            }
        }
        
    }
    
    
}
