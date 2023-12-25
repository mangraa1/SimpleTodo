//
//  TableViewController.swift
//  SimpleTodo
//
//  Created by mac on 10.10.2023.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    private var tasks = [Task]()

    //MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tasks = CoreDataManager.shared.loadTasks()
        tableView.reloadData()
    }

    //MARK: - @IBAction

    @IBAction func addTask(_ sender: Any) {
        let ac = UIAlertController(title: "New task", message: "Enter new task", preferredStyle: .alert)

        let taskAction = UIAlertAction(title: "Save", style: .default) { action in
            let tf = ac.textFields?.first
            if let newTask = tf?.text {
                CoreDataManager.shared.saveTask(withTitle: newTask)
                self.tasks = CoreDataManager.shared.loadTasks()
                self.tableView.reloadData()
            }
        }
        ac.addTextField()

        let cancelAction = UIAlertAction(title: "Cancel", style: .default)

        [cancelAction, taskAction].forEach { ac.addAction($0) }
        present(ac, animated: true)
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title

        return cell
    }

    //MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = tasks[indexPath.row]
            CoreDataManager.shared.deleteTask(task: taskToDelete)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
