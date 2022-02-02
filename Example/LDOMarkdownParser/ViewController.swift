//
//  ViewController.swift
//  LDOMarkdownParser
//
//  Created by Julian Raschke und Sebastian Ludwig GbR on 02/02/2022.
//  Copyright (c) 2022 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

import UIKit
import LDOMarkdownParser

class ViewController: UIViewController {
    @IBOutlet private weak var rawLabel: UILabel!
    @IBOutlet private weak var attributedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let markdownParser = LDOMarkdownParser()
        let input = "**Lorem ipsum** dolor sit amet, consetetur _sadipscing_ elitr, sed diam nonumy eirmod tempor invidunt. [Ut labore](http://example.com) et dolore **magna** aliquyam erat."
        rawLabel.text = input
        attributedLabel.attributedText = markdownParser.parse(input)
    }
}

