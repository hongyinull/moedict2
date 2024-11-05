import Foundation

extension DictResponse {
    static let preview: DictResponse = try! JSONDecoder().decode(DictResponse.self, from: """
    {
        "t": "好",
        "h": [
            {
                "d": [
                    {
                        "f": "美、善，理想的。",
                        "type": "形",
                        "e": ["如：「好東西」、「好風景」"],
                        "q": ["唐．韋莊．菩薩蠻：「人人盡說江南好」"]
                    }
                ],
                "b": "ㄏㄠˇ",
                "p": "hǎo"
            }
        ],
        "r": "女",
        "c": 6,
        "translation": {
            "English": ["good", "well", "proper", "nice"],
            "Deutsch": ["gut", "schön", "richtig"],
            "francais": ["bon", "bien"]
        }
    }
    """.data(using: .utf8)!)
} 