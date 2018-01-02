//
//  Tags_Items.swift
//  
//
//  Created by Don Sleeter on 7/29/17.
//
//  Currently unsed

import Foundation

public class Entry {
  public var subject = Tag()
  public var item = Item()
  public var timeStamp = Date()
}

public class Item {
  public var author = ""
  public var desc = ""
  public var tag = [Tag]()
}

public class Tag {
  public var name = ""
  public var count: Int?
}

