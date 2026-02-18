package router

import (
	"log"

	"server/handlers"
	"server/middleware"

	"github.com/gin-gonic/gin"
)

// SetupRouter 配置路由
// 返回配置好的Gin引擎
func SetupRouter() *gin.Engine {
	// 创建Gin引擎
	r := gin.New()
	r.Use(gin.Logger())
	r.Use(middleware.CORSMiddleware())
	r.Use(middleware.LoggerMiddleware())

	// 健康检查
	r.GET("/health", func(c *gin.Context) {
		log.Printf("[INFO] Health check")
		c.JSON(200, gin.H{"status": "ok"})
	})

	// API路由组
	api := r.Group("/api")
	{
		// 公开路由（无需认证）
		api.POST("/auth/register", handlers.Register)
		api.POST("/auth/login", handlers.Login)

		// 用户相关路由（需要认证）
		user := api.Group("/user")
		user.Use(middleware.AuthMiddleware())
		{
			user.GET("/profile", handlers.GetProfile)
			user.PUT("/profile", handlers.UpdateProfile)
			user.PUT("/level", handlers.UpdateLevel)
			user.PUT("/stats", handlers.UpdateStats)
		}
	}

	return r
}
