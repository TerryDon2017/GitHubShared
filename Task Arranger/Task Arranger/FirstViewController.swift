//
//  FirstViewController.swift
//  Task Arranger
//
//  Created by Don Ka Cheung on 26/12/2016.
//  Copyright © 2016年 Don Ka Cheung. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    var dbManager : DBManager = DBManager()
    let dbFileName = "taskdbv3.sql"
    var taskArray = [[String]]()
    var largestIndex : Int = 0
    @IBOutlet var textNew : UITextField!
    @IBOutlet var detailNew: UITextField!
    @IBOutlet var taskTable : UITableView!
    @IBOutlet var buttonTest : UIButton!
    @IBAction func buttonTest(_ sender: UIButton) {
        
        // Add task
        var q : String = "insert into tasks values("
        let newIndex = String(largestIndex + 1) as String!
        let inputText = textNew.text! as String
        let inputDetail = detailNew.text! as String
        q = q + newIndex! + ","
        q = q + "'" + inputText + "',"
        q = q + "'" + inputDetail + "',"
        q = q + "0);"
        NSLog(q)
        dbManager.executeQuery(q);
        
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
        textNew.delegate = self
        // Initialize the dbManager object.
        dbManager = DBManager(databaseFilename:dbFileName);
        
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
        return taskArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //set the cell content to display
        cell.textLabel?.text = taskArray[indexPath.row][1] as String
        cell.detailTextLabel?.text = taskArray[indexPath.row][2] as String
        if(taskArray[indexPath.row][3] as String == "1"){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //tasks.removeObject(at: indexPath.row)
        let deleteRowIndex:String = taskArray[indexPath.row][0]
        deleteRowSQL(deleteRowIndex: deleteRowIndex)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //mark complete / cancel in the table
        let selectRowIndex:String = taskArray[indexPath.row][0]
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            setSQLtaskComplete(selectRowIndex: selectRowIndex, setComplete: false)
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            setSQLtaskComplete(selectRowIndex: selectRowIndex, setComplete: true)
        }
    }
    func setSQLtaskComplete(selectRowIndex:String, setComplete:Bool){
        NSLog("set Index: " + selectRowIndex )
        var comp:Int = 0
        if(setComplete == true){
            comp = 1
        }
        dbManager.executeQuery("update tasks set completed = " + String(comp) + " where id = " + selectRowIndex)
        
    }
    func refreshTaskSQLite(){
        taskArray.removeAll()
        let query : NSString!
        query = "select * from tasks order by id asc;"
        var resultTable : NSArray
        resultTable = dbManager.loadData(fromDB: query as String!) as NSArray
        NSLog("task count = " + String(resultTable.count))
        
        //copy sqlite database into taskArray
        for  index in 0...(resultTable.count-1){
            let resultRow = resultTable[index] as! NSArray
            taskArray.append(resultRow as! [String])
            
            //find the largest id in the data
            let r = resultRow[0] as! String
            let j : Int = Int(r)!
            if(largestIndex < j) {
                largestIndex = j
            }
        }
    }
    func deleteRowSQL(deleteRowIndex:String){
        NSLog("Delete Index: " + deleteRowIndex )
        dbManager.executeQuery("delete from tasks where id = " + deleteRowIndex)
        if (dbManager.affectedRows != 0) {
            NSLog("Query was executed successfully. Affected rows = %d", dbManager.affectedRows);
        }
        else{
            NSLog("Could not execute the query.");
        }
        // refresh the Task Array
        refreshTaskSQLite()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}


