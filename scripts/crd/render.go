package main

import (
	"encoding/csv"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	// "errors"
	// "strconv"
)

func read_csv(csv_path string) ([][]string, error){
    csvFile, err := os.Open(csv_path)
    if err != nil {
        return [][]string{},  err
    }
    defer csvFile.Close()

    reader := csv.NewReader(csvFile)
    reader.FieldsPerRecord = -1

    csvData, err := reader.ReadAll()
    if err != nil {
        fmt.Println(err)
        return [][]string{}, err
    }

    return csvData, nil
}

func main() {
    template_path := flag.String("template_path", "./deployment-template.yaml", "Template path")
    // secret_name := flag.String("secret_name", "secret", "Ingress secret name")
    mode := flag.String("mode", "index", "Mode: index|csv")
    prefix := flag.String("prefix", "p", "Prefix, required if mode is index")
    index_range := flag.Int("index_range", -1, "Index range, required if mode is index")
    csv_path := flag.String("csv_path", "", "CSV path, required if mode is csv")
    flag.Parse()

	var template_buffer []byte
    template_fp, err:= os.OpenFile(*template_path, os.O_RDONLY, 0)
    if err != nil{
		fmt.Println("Read file err, err =", err)
		return
	}
    defer template_fp.Close()

    // read template file
    template_buffer, err = ioutil.ReadAll(template_fp)
    if err != nil {
        fmt.Println("Read file err, err =", err)
        return
    }

    // render secret into template
    template_string := string(template_buffer)
    // template_string = strings.Replace(template_string, "{{SECRET}}", *secret_name, -1)

    if *mode == "index" {
        if *index_range < 0 {
            fmt.Println("Invalid index")
            return
        }
        for idx := 0; idx < *index_range; idx++ {
            template_string_tmp := strings.Replace(template_string, "${{ ID }}", fmt.Sprintf("%s%03d", *prefix, idx), -1)
            err = ioutil.WriteFile(fmt.Sprintf("deployment-%03d.yaml", idx), []byte(template_string_tmp), 0644)
            if err != nil {
                fmt.Println("Write file err, err =", err)
                return
            }
        }
    } else if *mode == "csv" {
        var csv_content [][]string
        csv_content, err := read_csv(*csv_path)
        if err != nil {
            fmt.Println("Write file err, err =", err)
            return
        }

        for _, line := range csv_content {
            template_string_tmp := strings.Replace(template_string, "{{ID}}", line[0], -1)
            err = ioutil.WriteFile(fmt.Sprintf("deployment-%s.yaml", line[0]), []byte(template_string_tmp), 0644)
            if err != nil {
                fmt.Println("Write file err, err =", err)
                return
            }
        }
    } else {
        fmt.Println("Wrong mode, select mode from index|csv")
        return
    }
}