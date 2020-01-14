//
//  Observable+Distinct.swift
//  Hwahae
//
//  Created by 김효원 on 10/01/2020.
//  Copyright © 2020 김효원. All rights reserved.
//

import RxSwift

extension Observable where Element: Hashable {
   func distinct() -> Observable<Element> {
      var set = Set<Element>()
      return flatMap { element -> Observable<Element> in
        objc_sync_enter(self); defer {objc_sync_exit(self)}
         if set.contains(element) {
            return Observable<Element>.empty()
         } else {
            set.insert(element)
            return Observable<Element>.just(element)
         }
      }
   }
}
