package database

import (
	"log"
	"os"

	"server/models"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

// DB 全局数据库连接实例
var DB *gorm.DB

// InitDB 初始化数据库连接
func InitDB() {
	dbPath := "./data/kaikouyi.db"

	dir := "./data"
	if _, err := os.Stat(dir); os.IsNotExist(err) {
		if err := os.MkdirAll(dir, 0755); err != nil {
			log.Fatalf("Failed to create data directory: %v", err)
		}
	}

	var err error
	DB, err = gorm.Open(sqlite.Open(dbPath), &gorm.Config{
		Logger: logger.Default.LogMode(logger.Info),
	})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	err = DB.AutoMigrate(&models.User{})
	if err != nil {
		log.Fatalf("Failed to migrate database: %v", err)
	}

	log.Println("Database initialized successfully")
}

// CloseDB 关闭数据库连接
func CloseDB() {
	sqlDB, err := DB.DB()
	if err != nil {
		log.Printf("[WARN] CloseDB - Failed to get database instance: %v", err)
		return
	}
	if err := sqlDB.Close(); err != nil {
		log.Printf("[WARN] CloseDB - Failed to close database: %v", err)
	}
}

// GetDB 获取数据库实例
func GetDB() *gorm.DB {
	return DB
}
