//
//  CoreDataManager.swift
//  QRker
//
//  Created by  Mr.Ki on 06.05.2022.
//

import UIKit
import CoreData

class CoreDataManager {
    
    enum CoreDataErrors: Error {
        case failedToSave
        case failedToFetchData
        case failedToDelete
    }
    
    static let shared = CoreDataManager()
    
    func downloadNewsToDataBase(model: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let item = QrList(context: context)
        
       
        item.url = model
        
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataErrors.failedToSave))
            print(error.localizedDescription)
        }
    }
    
    func fetchNewsFromDataBase(completion : @escaping (Result<[QrList], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<QrList>
        request = QrList.fetchRequest()
        
        
        do {
            let news = try context.fetch(request)
            completion(.success(news))
        } catch {
            completion(.failure(CoreDataErrors.failedToFetchData))
        }
        
    }
    
    func deleteNewsFromDataBase(model: QrList, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(CoreDataErrors.failedToDelete))
        }
        
    }
    
}
