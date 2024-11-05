// 基礎定義結構
struct DictResponse: Codable {
    let title: String
    let heteronyms: [Heteronym]
    let radical: String?
    let strokeCount: Int?
    let translations: [String: [String]]?
    
    // 自定義解碼
    enum CodingKeys: String, CodingKey {
        case title = "t"
        case heteronyms = "h"
        case radical = "r"
        case strokeCount = "c"
        case translations = "translation"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 處理標題（去除分詞符號）
        let rawTitle = try container.decode(String.self, forKey: .title)
        title = rawTitle.removeWordMarkers()
        
        // 處理部首和筆畫
        radical = try container.decodeIfPresent(String.self, forKey: .radical)?.removeWordMarkers()
        strokeCount = try container.decodeIfPresent(Int.self, forKey: .strokeCount)
        
        // 處理翻譯
        translations = try container.decodeIfPresent([String: [String]].self, forKey: .translations)
        
        // 解碼異體字資訊
        let heteronymsArray = try container.decode([HeteronymRaw].self, forKey: .heteronyms)
        heteronyms = heteronymsArray.map { Heteronym(from: $0) }
    }
    
    // 新增編碼方法
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(radical, forKey: .radical)
        try container.encode(strokeCount, forKey: .strokeCount)
        try container.encode(translations, forKey: .translations)
        // 由於 Heteronym 已經轉換過，這裡需要特別處理
        try container.encode(heteronyms.map { $0.toRaw() }, forKey: .heteronyms)
    }
}

// 原始異體字資料結構
struct HeteronymRaw: Codable {
    let definitions: [DefinitionRaw]
    let bopomofo: String?
    let pinyin: String?
    let sound: String?  // 台語音標
    
    enum CodingKeys: String, CodingKey {
        case definitions = "d"
        case bopomofo = "b"
        case pinyin = "p"
        case sound = "T"  // 台語音標
    }
}

// 原始定義資料結構
struct DefinitionRaw: Codable {
    let definition: String
    let type: String?
    let example: [String]?
    let quote: [String]?
    let link: [String]?
    
    enum CodingKeys: String, CodingKey {
        case definition = "f"
        case type = "type"
        case example = "e"
        case quote = "q"
        case link = "l"
    }
}

// 處理後的異體字結構
struct Heteronym: Codable {
    let definitions: [Definition]
    let bopomofo: String?
    let pinyin: String?
    
    enum CodingKeys: String, CodingKey {
        case definitions
        case bopomofo
        case pinyin
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        definitions = try container.decode([Definition].self, forKey: .definitions)
        bopomofo = try container.decodeIfPresent(String.self, forKey: .bopomofo)
        pinyin = try container.decodeIfPresent(String.self, forKey: .pinyin)
    }
    
    init(from raw: HeteronymRaw) {
        self.bopomofo = raw.bopomofo
        self.pinyin = raw.pinyin ?? raw.sound
        self.definitions = raw.definitions.map { rawDef in
            Definition(
                def: rawDef.definition.removeWordMarkers(),
                type: rawDef.type?.removeWordMarkers(),
                example: rawDef.example?.map { $0.removeWordMarkers() },
                quote: rawDef.quote?.map { $0.removeWordMarkers() }
            )
        }
    }
    
    // 新增轉換回 Raw 格式的方法
    func toRaw() -> HeteronymRaw {
        HeteronymRaw(
            definitions: definitions.map { def in
                DefinitionRaw(
                    definition: def.def,
                    type: def.type,
                    example: def.example,
                    quote: def.quote,
                    link: nil
                )
            },
            bopomofo: bopomofo,
            pinyin: pinyin,
            sound: nil
        )
    }
}

// 處理後的定義結構
struct Definition: Codable {
    let def: String
    let type: String?
    let example: [String]?
    let quote: [String]?
}

// String 擴展，用於處理分詞符號
extension String {
    func removeWordMarkers() -> String {
        self.replacingOccurrences(of: "`", with: "")
            .replacingOccurrences(of: "~", with: "")
    }
} 