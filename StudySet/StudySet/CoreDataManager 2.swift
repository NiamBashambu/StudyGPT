import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "QuizDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func fetchStudyPlans() -> [StudyPlanResponse] {
        let fetchRequest: NSFetchRequest<StudyPlanEntity> = StudyPlanEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.map { entity in
                StudyPlanResponse(
                    id: entity.id,
                    title: entity.title,
                    studyPlan: entity.studyPlan,
                    dueDate: entity.dueDate,
                    type: entity.type
                )
            }
        } catch {
            print("Error fetching study plans: \(error)")
            return []
        }
    }
    
    func saveStudyPlans(_ plans: [StudyPlanResponse]) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = StudyPlanEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error deleting study plans: \(error)")
        }
        
        for plan in plans {
            let entity = StudyPlanEntity(context: context)
            entity.id = plan.id
            entity.title = plan.title
            entity.dueDate = plan.dueDate
            entity.type = plan.type
            entity.studyPlan = plan.studyPlan
        }
        
        saveContext()
    }
}