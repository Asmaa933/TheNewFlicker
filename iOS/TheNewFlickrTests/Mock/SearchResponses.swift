//
//  Responses.swift
//  TheNewFlickrTests
//
//  Created by Asmaa Tarek on 15/07/2021.
//

import Foundation

let searchResponse: [String: Any] = [
    "photos": [
        "page": 1,
        "pages": 2,
        "perpage": 3,
        "total": 6,
        "photo": [
            [
                "id": "51311711581",
                "owner": "182925621@N07",
                "secret": "52fe2d1263",
                "server": "65535",
                "farm": 66,
                "title": "CAT (1)",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
            ],
            [
                "id": "51312436084",
                "owner": "182925621@N07",
                "secret": "33e4bd20c5",
                "server": "65535",
                "farm": 66,
                "title": "CAT (3)",
                "ispublic": 1,
                "isfriend": 0,
            ],
            [
                "id": "51312436084",
                "owner": "182925621@N07",
                "secret": "33e4bd20c5",
                "server": "65535",
                "farm": 66,
                "title": "CAT (3)",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
            ]
        ]
    ],
    "stat": "ok"
]

let successResponse2: [String: Any] = [
    "photos": [
        "page": 2,
        "pages": 2,
        "perpage": 3,
        "total": 6,
        "photo": [
            [
                "id": "51312698925",
                "owner": "105954067@N08",
                "secret": "a4fd1e32fd",
                "server": "65535",
                "farm": 66,
                "title": "8927-031",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
            ],
            [
                "id": "51312418664",
                "owner": "88422721@N00",
                "secret": "31263f7739",
                "server": "65535",
                "farm": 66,
                "title": "Ash 2",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
            ],
            [
                "id": "51311693001",
                "owner": "88422721@N00",
                "secret": "2b6043c26f",
                "server": "65535",
                "farm": 66,
                "title": "Gregory Bellbottoms 1",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
            ],
            
        ],
        "stat": "ok"
    ]
]
