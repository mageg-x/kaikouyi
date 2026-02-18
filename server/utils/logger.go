package utils

import (
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"time"
)

var (
	logger       *log.Logger
	errorLogger  *log.Logger
	accessLogger *log.Logger
	logFile      *os.File
	accessFile   *os.File
	logLevel     = "INFO"
)

// LogLevel 日志级别
type LogLevel int

const (
	DEBUG LogLevel = iota
	INFO
	WARN
	ERROR
	FATAL
)

var levelMap = map[string]LogLevel{
	"DEBUG": DEBUG,
	"INFO":  INFO,
	"WARN":  WARN,
	"ERROR": ERROR,
	"FATAL": FATAL,
}

// InitLogger 初始化日志系统
func InitLogger() {
	dir := "./logs"
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		if err := os.MkdirAll(dir, 0755); err != nil {
			log.Fatalf("Failed to create logs directory: %v", err)
		}
	}

	// 主日志文件
	logFileName := filepath.Join(dir, fmt.Sprintf("app_%s.log", time.Now().Format("2006-01-02")))
	file, err := os.OpenFile(logFileName, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("Failed to open log file: %v", err)
	}
	logFile = file

	// 错误日志文件
	errorFileName := filepath.Join(dir, fmt.Sprintf("error_%s.log", time.Now().Format("2006-01-02")))
	errorFile, err := os.OpenFile(errorFileName, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("Failed to open error log file: %v", err)
	}

	// 访问日志文件
	accessFileName := filepath.Join(dir, fmt.Sprintf("access_%s.log", time.Now().Format("2006-01-02")))
	accessF, err := os.OpenFile(accessFileName, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalf("Failed to open access log file: %v", err)
	}
	accessFile = accessF

	// 创建多Writer日志器
	logger = log.New(io.MultiWriter(file, os.Stdout), "", log.LstdFlags|log.Lshortfile)
	errorLogger = log.New(io.MultiWriter(errorFile, os.Stderr), "", log.LstdFlags|log.Lshortfile)
	accessLogger = log.New(accessF, "", log.LstdFlags)

	logger.Println("Logger initialized successfully")
}

// CloseLogger 关闭日志文件
func CloseLogger() {
	if logFile != nil {
		logFile.Close()
	}
	if accessFile != nil {
		accessFile.Close()
	}
}

// SetLogLevel 设置日志级别
func SetLogLevel(level string) {
	logLevel = level
}

// Debug 调试日志
func Debug(format string, v ...interface{}) {
	if levelMap[logLevel] <= DEBUG {
		logger.Printf("[DEBUG] "+format, v...)
	}
}

// Info 信息日志
func Info(format string, v ...interface{}) {
	if levelMap[logLevel] <= INFO {
		logger.Printf("[INFO] "+format, v...)
	}
}

// Warn 警告日志
func Warn(format string, v ...interface{}) {
	if levelMap[logLevel] <= WARN {
		logger.Printf("[WARN] "+format, v...)
	}
}

// Error 错误日志
func Error(format string, v ...interface{}) {
	if levelMap[logLevel] <= ERROR {
		errorLogger.Printf("[ERROR] "+format, v...)
	}
}

// Fatal 致命错误日志
func Fatal(format string, v ...interface{}) {
	if levelMap[logLevel] <= FATAL {
		errorLogger.Fatalf("[FATAL] "+format, v...)
	}
}

// Access 访问日志
func Access(format string, v ...interface{}) {
	accessLogger.Printf(format, v...)
}

// GetLogger 获取主日志器
func GetLogger() *log.Logger {
	return logger
}

// GetErrorLogger 获取错误日志器
func GetErrorLogger() *log.Logger {
	return errorLogger
}

// GetAccessLogger 获取访问日志器
func GetAccessLogger() *log.Logger {
	return accessLogger
}
