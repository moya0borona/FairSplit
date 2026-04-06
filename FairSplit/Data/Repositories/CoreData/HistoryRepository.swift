import CoreData
import Foundation

typealias CalculationEntity = ObsidianCalcGlyph
typealias CalculationPersonEntity = ObsidianPersonGlyph

final class HistoryRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createCalculation(total: Double, tipFraction: Double, people: Int, resultPerPerson: Double) throws {
        let calc = CalculationEntity(context: context)
        calc.id = UUID().uuidString
        calc.date = Date()
        calc.total = total
        calc.tip = tipFraction
        calc.people = Int16(people)
        calc.result = resultPerPerson

        try context.save()
    }

    func delete(_ obj: NSManagedObject) throws {
        context.delete(obj)
        try context.save()
    }
}

