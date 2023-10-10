//
//  CoreDataManager.swift
//  SimpleTodo
//
//  Created by mac on 10.10.2023.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    //MARK: - Public

    public func saveTask(withTitle title: String) {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }

        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        taskObject.date = Date.now

        do {
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    public func deleteTask(task: Task) {
        let context = getContext()
        context.delete(task)

        do {
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    public func loadTasks() -> [Task] {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }

    //MARK: - Private
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
