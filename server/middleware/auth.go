package middleware

import (
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"server/utils"
)

// AuthMiddleware JWT认证中间件
// 验证请求头中的Bearer Token
func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			utils.Warn("AuthMiddleware - No Authorization header")
			c.JSON(401, gin.H{"error": "Authorization header required"})
			c.Abort()
			return
		}

		tokenString := authHeader
		if len(tokenString) > 7 && tokenString[:7] == "Bearer " {
			tokenString = tokenString[7:]
		} else {
			utils.Warn("AuthMiddleware - Invalid Bearer token format")
			c.JSON(401, gin.H{"error": "Bearer token required"})
			c.Abort()
			return
		}

		claims, err := utils.ValidateToken(tokenString)
		if err != nil {
			utils.Warn("AuthMiddleware - Invalid token: %v", err)
			c.JSON(401, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		utils.Debug("AuthMiddleware - Authenticated: UserID=%d, Username=%s", claims.UserID, claims.Username)
		c.Set("userID", claims.UserID)
		c.Set("username", claims.Username)
		c.Next()
	}
}

// CORSMiddleware CORS跨域中间件
// 允许前端跨域访问API
func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

// LoggerMiddleware 日志中间件
// 记录每个请求的详细信息
func LoggerMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		startTime := time.Now()

		// 处理请求
		c.Next()

		// 请求结束后记录日志
		endTime := time.Now()
		latency := endTime.Sub(startTime)
		clientIP := c.ClientIP()
		method := c.Request.Method
		path := c.Request.URL.Path
		statusCode := c.Writer.Status()

		// 记录访问日志
		logMsg := fmt.Sprintf("%s | %3d | %13v | %15s | %-7s %s",
			endTime.Format("2006-01-02 15:04:05"),
			statusCode,
			latency,
			clientIP,
			method,
			path,
		)

		if statusCode >= 400 {
			utils.Warn("%s", logMsg)
		} else {
			utils.Info("%s", logMsg)
		}
	}
}
