import CoreData
import XCTest

@testable import ToDo_List

final class ToDo_ListTests: XCTestCase {
    var persistenceController: PersistenceController!
    var taskListViewModel: TaskListViewModel!
    var taskRedactorViewModel: TaskRedactorViewModel!

    override func setUp() {
        super.setUp()
        // Создаем тестовый PersistenceController с in-memory store
        persistenceController = PersistenceController(inMemory: true)
        taskListViewModel = TaskListViewModel(persistenceController: persistenceController)
    }

    override func tearDown() {
        persistenceController = nil
        taskListViewModel = nil
        taskRedactorViewModel = nil
        super.tearDown()
    }

    // MARK: - TaskListViewModel Tests
    func testAddNewTask() {
        // Given
        let initialTaskCount = taskListViewModel.tasks.count
        let taskTitle = "Test Task"
        let taskDescription = "Test Description"

        // When
        taskListViewModel.addTask(title: taskTitle, description: taskDescription)

        // Then
        XCTAssertEqual(taskListViewModel.tasks.count, initialTaskCount + 1)
        let addedTask = taskListViewModel.tasks.last?.task
        XCTAssertEqual(addedTask?.title, taskTitle)
        XCTAssertEqual(addedTask?.description, taskDescription)
        XCTAssertFalse(addedTask?.isDone ?? true)
    }

    func testFilterTasks() {
        // Given
        taskListViewModel.addTask(title: "Buy groceries", description: "Milk and bread")
        taskListViewModel.addTask(title: "Call mom", description: "About dinner")

        // When
        taskListViewModel.searchText = "groceries"

        // Then
        XCTAssertEqual(taskListViewModel.filteredTasks.count, 1)
        XCTAssertEqual(taskListViewModel.filteredTasks.first?.task.title, "Buy groceries")
    }

    func testDeleteTask() {
        // Given
        taskListViewModel.addTask(title: "Test Task", description: "To be deleted")
        let initialTaskCount = taskListViewModel.tasks.count
        let taskToDelete = taskListViewModel.tasks.last!

        // When
        taskListViewModel.deleteTask(taskToDelete)

        // Then
        XCTAssertEqual(taskListViewModel.tasks.count, initialTaskCount - 1)
        XCTAssertFalse(
            taskListViewModel.tasks.contains(where: { $0.task.id == taskToDelete.task.id }))
    }

    // MARK: - TaskRedactorViewModel Tests

    func testSaveNewTask() {
        // Given
        let task = ToDoTask(title: "New Task", description: "Test Description")
        taskRedactorViewModel = TaskRedactorViewModel(
            task: task,
            isNewTask: true,
            persistenceController: persistenceController
        )

        // When
        taskRedactorViewModel.saveTask()
        taskListViewModel.loadLocalTasks()

        // Then
        XCTAssertTrue(taskListViewModel.tasks.contains(where: { $0.task.title == "New Task" }))
    }

    // MARK: - TaskViewModel Tests

    func testToggleTaskCompletion() {
        // Given
        let task = ToDoTask(title: "Test Task", description: "Test Description")
        let taskViewModel = TaskViewModel(task: task)
        let initialState = taskViewModel.task.isDone

        // When
        taskViewModel.onDone()

        // Then
        XCTAssertEqual(taskViewModel.task.isDone, !initialState)
    }
}
