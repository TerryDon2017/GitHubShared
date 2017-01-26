//
//  FirstViewController.swift
//  Task Arranger
//
//  Created by Don Ka Cheung on 26/12/2016.
//  Copyright © 2016年 Don Ka Cheung. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet var buttonTest: UIButton!
    @IBAction func buttonTest(_ sender: UIButton) {
        
        
        var dbManager: DBManager = DBManager()
        // Prepare the query string.
        var query : NSString!
        query = "insert into peopleInfo values(null, '%@', '%@', %d)";
        
        // Execute the query.
        dbManager.executeQuery(query as String!);
        
        // If the query was successfully executed then pop the view controller.
        if (dbManager.affectedRows != 0) {
            NSLog("Query was executed successfully. Affected rows = %d", dbManager.affectedRows);
            
            // Pop the view controller.
            //navigationController popViewControllerAnimated:YES;
        }
        else{
            NSLog("Could not execute the query.");
        }
        
        tasks.add(textNew.text!)
        taskTable.reloadData()
    }
    
    @IBOutlet var textNew: UITextField!
    @IBOutlet var taskTable: UITableView!
    var tasks:NSMutableArray = ["Eat an Apple","Do the homework","Play a game"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taskTable.dataSource = self
        taskTable.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tasks.removeObject(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
       
}


