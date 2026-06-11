package main

import (
	"fmt"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"
	"unicode/utf8"
)

var filePattern = regexp.MustCompile(`^(\d{4}-\d{2})(.*)$`)

type rowMap map[string]map[string]string

func main() {
	dir := "."
	if len(os.Args) > 1 {
		dir = os.Args[1]
	}

	entries, err := os.ReadDir(dir)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	rows := rowMap{}
	monthSet := map[string]struct{}{}
	otherFiles := []string{}

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}

		name := entry.Name()
		if strings.HasPrefix(name, ".") {
			continue
		}

		name = strings.TrimSuffix(name, filepath.Ext(name))
		match := filePattern.FindStringSubmatch(name)
		if match == nil {
			otherFiles = append(otherFiles, entry.Name())
			continue
		}

		month := match[1]
		suffix := strings.TrimLeft(match[2], "-_. ")
		if suffix == "" {
			suffix = "(no suffix)"
		}

		monthSet[month] = struct{}{}
		if rows[suffix] == nil {
			rows[suffix] = map[string]string{}
		}
		rows[suffix][month] = entry.Name()
	}

	if len(rows) > 0 {
		printTable(dir, sortedKeys(monthSet), rows)
	}

	printOtherFiles(dir, otherFiles)
}

func printTable(dir string, months []string, rows rowMap) {
	const monthWidth = len("YYYY-MM") + 2

	suffixes := sortedKeys(rows)

	suffixWidth := 2
	for _, suffix := range suffixes {
		suffixWidth = max(suffixWidth, utf8.RuneCountInString(suffix)+2)
	}

	printPadded("", suffixWidth)
	for _, month := range months {
		printPadded(month, monthWidth)
	}
	fmt.Println()

	for _, suffix := range suffixes {
		printPadded(suffix, suffixWidth)
		for _, month := range months {
			if file := rows[suffix][month]; file != "" {
				printLinkedPadded(dir, file, "✓", monthWidth)
			} else {
				printPadded("", monthWidth)
			}
		}
		fmt.Println()
	}
}

func printOtherFiles(dir string, files []string) {
	if len(files) == 0 {
		return
	}

	sort.Strings(files)
	fmt.Println()
	fmt.Println("Other files:")
	for _, file := range files {
		fmt.Println(fileLink(dir, file, file))
	}
}

func printPadded(text string, width int) {
	fmt.Print(text)
	printPadding(text, width)
}

func printLinkedPadded(dir, name, text string, width int) {
	fmt.Print(fileLink(dir, name, text))
	printPadding(text, width)
}

func printPadding(text string, width int) {
	textWidth := utf8.RuneCountInString(text)
	if padding := width - textWidth; padding > 0 {
		fmt.Print(strings.Repeat(" ", padding))
	}
}

func fileLink(dir, name, text string) string {
	path := filepath.Join(dir, name)
	abs, err := filepath.Abs(path)
	if err != nil {
		return text
	}

	uri := url.URL{Scheme: "file", Path: abs}
	return fmt.Sprintf("\x1b]8;;%s\x1b\\%s\x1b]8;;\x1b\\", uri.String(), text)
}

func sortedKeys[T any](m map[string]T) []string {
	keys := make([]string, 0, len(m))
	for key := range m {
		keys = append(keys, key)
	}
	sort.Strings(keys)
	return keys
}
