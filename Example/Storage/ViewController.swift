//
//  ViewController.swift
//  Storage
//
//  Created by rizwankce on 12/19/2017.
//  Copyright (c) 2017 rizwankce. All rights reserved.
//

import UIKit
import Storage

enum Result<T> {
    case success(T)
    case failure(Error)
}

class ViewController: UIViewController {

    private let storage: Storage<[Job]> = Storage(storageType: .document, filename: "remote-jobs.json")
    private var jobs = [Job]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let jobs = storage.storedValue {
            self.jobs = jobs
        }
        else {
            fetch() { (result)  in
                switch result {
                case .success(let jobs):
                    self.storage.save(jobs)
                    self.jobs = jobs
                case .failure(let error):
                    fatalError("error: \(error.localizedDescription)")
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


    }

    func fetch(_ completion: ((Result<[Job]>) -> Void)?) {
        guard let url = URL(string: "https://remoteok.io/remote-jobs.json") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let jobs = try decoder.decode([Job].self, from: data)
                completion?(.success(jobs))
            } catch {
                completion?(.failure(error))
            }
        }).resume()
    }
}
