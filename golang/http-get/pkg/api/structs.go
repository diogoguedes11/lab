package api


type Occurrence struct {
	Page  string   `json:"page"` // we look for the page attribute
	Words map[string]int `json:"words"` // we look for the words attribute
}
type Page struct {
	Name  string   `json:"page"` // we look for the page attribute
}
//  {"page":"words","input":"word1","words":["word1"]}
type Words struct {
	Page  string   `json:"page"` // we look for the page attribute
	Input string  `json:"input"`
	Words []string `json:"words"` // we look for the words attribute
	
}

