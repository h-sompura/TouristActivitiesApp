import Foundation

class TicketPurchase: Codable {
  let nameOfActivity: String
  let quantity: Int
  private let price: Double
  let dateOfVisit: String
  var totalCostOfPurchase: Double {
    return Double(quantity) * price
  }

  init(nameOfActivity: String, quantity: Int, price: Double, dateOfVisit: String) {
    self.nameOfActivity = nameOfActivity
    self.dateOfVisit = dateOfVisit
    self.quantity = quantity
    self.price = price
  }

}

extension TicketPurchase: CustomStringConvertible {
  var description: String {
    return "\(self.nameOfActivity),  $\(self.price)*\(self.quantity), \(self.dateOfVisit)"
  }
}

