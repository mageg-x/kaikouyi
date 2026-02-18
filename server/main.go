package main

import (
	"log"
	"server/database"
	"server/router"
	"server/utils"
)

func main() {
	log.Println("========================================")
	log.Println("Starting KaiKouYi Server...")
	log.Println("========================================")

	// 初始化日志
	utils.InitLogger()
	defer utils.CloseLogger()

	// 初始化数据库
	database.InitDB()
	defer database.CloseDB()

	// 设置路由
	r := router.SetupRouter()

	log.Println("Server starting on :8080")
	log.Println("========================================")
	if err := r.Run(":8080"); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
