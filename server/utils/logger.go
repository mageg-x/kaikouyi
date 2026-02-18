package utils

import (
	"fmt"
	"log"
	"os"
	"time"
)

var logFile *os.File

// InitLogger 初始化日志系统
func InitLogger() {
	dir := "./logs"
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		if err := os.MkdirAll(dir, 0755); err != nil {
			log.Fatalf("Failed to create logs directory: %v", err)
		}
	}

	logFileName := fmt.Sprintf("%s/kaikouyi_%s.log", dir, time.Now().Format("2006-01-02"))
	file, err := os.OpenFile(logFileName, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("Failed to open log file: %v", err)
	}
	logFile = file

	log.SetOutput(file)
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	log.Println("Logger initialized successfully")
}

// CloseLogger 关闭日志文件
func CloseLogger() {
	if logFile != nil {
		logFile.Close()
	}
}
