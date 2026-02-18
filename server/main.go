package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"server/database"
	"server/router"
	"server/utils"
)

var (
	host string
	port int
)

func init() {
	flag.StringVar(&host, "host", "0.0.0.0", "Server host")
	flag.IntVar(&port, "port", 8080, "Server port")
	flag.Parse()
}

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

	addr := fmt.Sprintf("%s:%d", host, port)
	log.Printf("Server starting on %s", addr)
	log.Println("========================================")
	if err := r.Run(addr); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

func printUsage() {
	fmt.Fprintf(os.Stderr, "Usage: %s [options]\n", os.Args[0])
	flag.PrintDefaults()
}
