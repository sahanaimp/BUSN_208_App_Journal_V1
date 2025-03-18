/* Week 1:
1. Think of an app like Splitwise and design a data structure for such an app. Then write a function that can be called to compute who owes how much and to whom.
*/

import Foundation

struct Transaction {
    let payer: String
    let amount: Double
    let participants: [String]
}

class BalanceSheet {
    private var balances: [String: Double] = [:]

    func addTransaction(_ transaction: Transaction) {
        let share = transaction.amount / Double(transaction.participants.count)
        
        for participant in transaction.participants {
            balances[participant, default: 0] -= share
        }
        
        balances[transaction.payer, default: 0] += transaction.amount
    }

    func calculateBalances() -> [(String, String, Double)] {
        var result: [(String, String, Double)] = []
        var creditors = balances.filter { $0.value > 0 }.sorted { $0.value > $1.value }
        var debtors = balances.filter { $0.value < 0 }.sorted { $0.value < $1.value }

        while !creditors.isEmpty && !debtors.isEmpty {
            let (creditor, creditAmount) = creditors.removeFirst()
            let (debtor, debtAmount) = debtors.removeFirst()
            
            let minAmount = min(creditAmount, -debtAmount)
            result.append((debtor, creditor, minAmount))

            if creditAmount > minAmount {
                creditors.insert((creditor, creditAmount - minAmount), at: 0)
            }
            if -debtAmount > minAmount {
                debtors.insert((debtor, debtAmount + minAmount), at: 0)
            }
        }

        return result
    }
}
