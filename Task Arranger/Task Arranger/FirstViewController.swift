//
//  FirstViewController.swift
//  Task Arranger
//
//  Created by Don Ka Cheung on 26/12/2016.
//  Copyright © 2016年 Don Ka Cheung. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var dbManager : DBManager = DBManager()
    var tasks : NSMutableArray = ["feed the cat","kick the ball","Play a game"]
    var taskArray = [[String]]()
    var largestIndex : Int = 0
    @IBOutlet var textNew : UITextField!
    @IBOutlet var taskTable : UITableView!
    @IBOutlet var buttonTest : UIButton!
    @IBAction func buttonTest(_ sender: UIButton) {
        
        // Prepare the query string.
        let query : NSString!
        let newIndex : String!
        let inputText : String
        newIndex = String(largestIndex + 1) as String!
        inputText = textNew.text!
        query = "insert into tasks values(" + newIndex +  ",'" + inputText + "');" as NSString!
        
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
        
        // refresh the Task Array
        refreshTaskSQLite()
        
        taskTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taskTable.dataSource = self
        taskTable.delegate = self
        
        // Initialize the dbManager object.
        dbManager = DBManager(databaseFilename:"newtask.sql");
        
        // refresh the Task Array
        refreshTaskSQLite()
        
        
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
        let deleteRowIndex:String = taskArray[indexPath.row][0]
        NSLog("Delete Index: " + deleteRowIndex )
        deleteRowSQL(deleteRowIndex: deleteRowIndex)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    func refreshTaskSQLite(){
        tasks.removeAllObjects()
        taskArray.removeAll()
        
        let query : NSString!
        query = "select * from tasks order by id asc;"
        var resultTable : NSArray
        resultTable = dbManager.loadData(fromDB: query as String!) as NSArray
        NSLog("task count = " + String(resultTable.count))
        for  index in 0...(resultTable.count-1){
            let resultRow = resultTable[index] as! NSArray
            taskArray.append(resultRow as! [String])
            tasks.add(resultRow[1])
            let r = resultRow[0] as! String
            let j : Int = Int(r)!
            if(largestIndex < j) {
                largestIndex = j
            }
        }
    }
    func deleteRowSQL(deleteRowIndex:String){
        
    }
}


