package handlers

import (
	"log"
	"net/http"

	"server/database"
	"server/models"
	"server/utils"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
)

// RegisterRequest 注册请求结构
type RegisterRequest struct {
	Username string `json:"username" binding:"required,min=3,max=50"`
	Password string `json:"password" binding:"required,min=6"`
	Name     string `json:"name" binding:"required"`
}

// LoginRequest 登录请求结构
type LoginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

// AuthResponse 认证响应结构
type AuthResponse struct {
	Token string      `json:"token"`
	User  models.User `json:"user"`
}

// Register 处理用户注册
// POST /api/auth/register
func Register(c *gin.Context) {
	var req RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[WARN] Register - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Printf("[INFO] Register - Username: %s", req.Username)

	// 检查用户名是否已存在
	var existingUser models.User
	if err := database.DB.Where("username = ?", req.Username).First(&existingUser).Error; err == nil {
		log.Printf("[WARN] Register - Username already exists: %s", req.Username)
		c.JSON(http.StatusConflict, gin.H{"error": "用户名已存在"})
		return
	}

	// 密码加密
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		log.Printf("[ERROR] Register - Password hash failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "密码加密失败"})
		return
	}

	// 创建用户
	user := models.User{
		Username: req.Username,
		Password: string(hashedPassword),
		Name:     req.Name,
		Level:    models.GetDefaultLevel(),
		Stats:    models.GetDefaultStats(),
	}

	if err := database.DB.Create(&user).Error; err != nil {
		log.Printf("[ERROR] Register - Create user failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "创建用户失败"})
		return
	}

	// 生成JWT令牌
	token, err := utils.GenerateToken(user.ID, user.Username)
	if err != nil {
		log.Printf("[ERROR] Register - Generate token failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "生成令牌失败"})
		return
	}

	log.Printf("[INFO] Register - User created successfully: ID=%d, Username=%s", user.ID, user.Username)
	c.JSON(http.StatusCreated, AuthResponse{
		Token: token,
		User:  user,
	})
}

// Login 处理用户登录
// POST /api/auth/login
func Login(c *gin.Context) {
	var req LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[WARN] Login - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Printf("[INFO] Login - Username: %s", req.Username)

	// 查找用户
	var user models.User
	if err := database.DB.Where("username = ?", req.Username).First(&user).Error; err != nil {
		log.Printf("[WARN] Login - User not found: %s", req.Username)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "用户名或密码错误"})
		return
	}

	// 验证密码
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		log.Printf("[WARN] Login - Password mismatch: %s", req.Username)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "用户名或密码错误"})
		return
	}

	// 生成JWT令牌
	token, err := utils.GenerateToken(user.ID, user.Username)
	if err != nil {
		log.Printf("[ERROR] Login - Generate token failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "生成令牌失败"})
		return
	}

	log.Printf("[INFO] Login - Success: ID=%d, Username=%s", user.ID, user.Username)
	c.JSON(http.StatusOK, AuthResponse{
		Token: token,
		User:  user,
	})
}

// GetProfile 获取用户信息
// GET /api/profile
func GetProfile(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		log.Printf("[WARN] GetProfile - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	log.Printf("[DEBUG] GetProfile - UserID: %v", userID)

	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		log.Printf("[ERROR] GetProfile - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// UpdateProfile 更新用户信息
// PUT /api/profile
func UpdateProfile(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		log.Printf("[WARN] UpdateProfile - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	var req struct {
		Name string `json:"name"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[WARN] UpdateProfile - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Printf("[INFO] UpdateProfile - UserID: %v, Name: %s", userID, req.Name)

	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		log.Printf("[ERROR] UpdateProfile - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	if req.Name != "" {
		user.Name = req.Name
	}

	if err := database.DB.Save(&user).Error; err != nil {
		log.Printf("[ERROR] UpdateProfile - Update failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新失败"})
		return
	}

	log.Printf("[INFO] UpdateProfile - Success: UserID=%v", userID)
	c.JSON(http.StatusOK, user)
}

// UpdateLevel 更新用户等级
// PUT /api/level
func UpdateLevel(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		log.Printf("[WARN] UpdateLevel - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	var level models.UserLevel
	if err := c.ShouldBindJSON(&level); err != nil {
		log.Printf("[WARN] UpdateLevel - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Printf("[INFO] UpdateLevel - UserID: %v, Level: %+v", userID, level)

	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		log.Printf("[ERROR] UpdateLevel - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	user.Level = level
	if err := database.DB.Save(&user).Error; err != nil {
		log.Printf("[ERROR] UpdateLevel - Update failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新失败"})
		return
	}

	log.Printf("[INFO] UpdateLevel - Success: UserID=%v", userID)
	c.JSON(http.StatusOK, user)
}

// UpdateStats 更新学习统计
// PUT /api/stats
func UpdateStats(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		log.Printf("[WARN] UpdateStats - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	var stats models.UserStats
	if err := c.ShouldBindJSON(&stats); err != nil {
		log.Printf("[WARN] UpdateStats - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Printf("[INFO] UpdateStats - UserID: %v, Stats: %+v", userID, stats)

	var user models.User
	if err := database.DB.First(&user, userID).Error; err != nil {
		log.Printf("[ERROR] UpdateStats - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	user.Stats = stats
	if err := database.DB.Save(&user).Error; err != nil {
		log.Printf("[ERROR] UpdateStats - Update failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新失败"})
		return
	}

	log.Printf("[INFO] UpdateStats - Success: UserID=%v", userID)
	c.JSON(http.StatusOK, user)
}
