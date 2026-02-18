package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"server/database"
	"server/models"
	"server/utils"
)

// RegisterRequest 注册请求结构
type RegisterRequest struct {
	Username string `json:"username" binding:"required,min=3,max=50"`
	Password string `json:"password" binding:"required,min=6"`
	Nickname string `json:"nickname" binding:"required"`
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
		utils.Warn("Register - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	utils.Info("Register - Username: %s", req.Username)

	// 检查用户名是否已存在
	var existingUser models.User
	if err := database.GetDB().Where("username = ?", req.Username).First(&existingUser).Error; err == nil {
		utils.Warn("Register - Username already exists: %s", req.Username)
		c.JSON(http.StatusConflict, gin.H{"error": "用户名已存在"})
		return
	}

	// 密码加密
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		utils.Error("Register - Password hash failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "密码加密失败"})
		return
	}

	// 创建用户
	user := models.User{
		Username: req.Username,
		Password: string(hashedPassword),
		Nickname: req.Nickname,
		Level:    models.GetDefaultLevel(),
		Stats:    models.GetDefaultStats(),
	}

	if err := database.GetDB().Create(&user).Error; err != nil {
		utils.Error("Register - Create user failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "创建用户失败"})
		return
	}

	// 生成JWT令牌
	token, err := utils.GenerateToken(user.ID, user.Username)
	if err != nil {
		utils.Error("Register - Generate token failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "生成令牌失败"})
		return
	}

	utils.Info("Register - User created successfully: ID=%d, Username=%s", user.ID, user.Username)
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
		utils.Warn("Login - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	utils.Info("Login - Username: %s", req.Username)

	// 查找用户
	var user models.User
	if err := database.GetDB().Where("username = ?", req.Username).First(&user).Error; err != nil {
		utils.Warn("Login - User not found: %s", req.Username)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "用户名或密码错误"})
		return
	}

	// 验证密码
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password)); err != nil {
		utils.Warn("Login - Password mismatch: %s", req.Username)
		c.JSON(http.StatusUnauthorized, gin.H{"error": "用户名或密码错误"})
		return
	}

	// 生成JWT令牌
	token, err := utils.GenerateToken(user.ID, user.Username)
	if err != nil {
		utils.Error("Login - Generate token failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "生成令牌失败"})
		return
	}

	utils.Info("Login - Success: ID=%d, Username=%s", user.ID, user.Username)
	c.JSON(http.StatusOK, AuthResponse{
		Token: token,
		User:  user,
	})
}

// GetProfile 获取用户信息
// GET /api/user/profile
func GetProfile(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		utils.Warn("GetProfile - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	utils.Debug("GetProfile - UserID: %v", userID)

	var user models.User
	if err := database.GetDB().First(&user, userID).Error; err != nil {
		utils.Error("GetProfile - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// UpdateProfileRequest 更新用户信息请求
type UpdateProfileRequest struct {
	Nickname string `json:"nickname"`
	Avatar   string `json:"avatar"`
}

// UpdateProfile 更新用户信息
// PUT /api/user/profile
func UpdateProfile(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		utils.Warn("UpdateProfile - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	var req UpdateProfileRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		utils.Warn("UpdateProfile - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	utils.Info("UpdateProfile - UserID: %v, Nickname: %s, Avatar: %s", userID, req.Nickname, req.Avatar)

	var user models.User
	if err := database.GetDB().First(&user, userID).Error; err != nil {
		utils.Error("UpdateProfile - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	if req.Nickname != "" {
		user.Nickname = req.Nickname
	}
	if req.Avatar != "" {
		user.Avatar = req.Avatar
	}

	if err := database.GetDB().Save(&user).Error; err != nil {
		utils.Error("UpdateProfile - Update failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新失败"})
		return
	}

	utils.Info("UpdateProfile - Success: UserID=%v", userID)
	c.JSON(http.StatusOK, user)
}

// UpdateLevel 更新用户等级
// PUT /api/user/level
func UpdateLevel(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		utils.Warn("UpdateLevel - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	var level models.UserLevel
	if err := c.ShouldBindJSON(&level); err != nil {
		utils.Warn("UpdateLevel - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	utils.Info("UpdateLevel - UserID: %v, Level: %+v", userID, level)

	var user models.User
	if err := database.GetDB().First(&user, userID).Error; err != nil {
		utils.Error("UpdateLevel - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	user.Level = level
	if err := database.GetDB().Save(&user).Error; err != nil {
		utils.Error("UpdateLevel - Update failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新失败"})
		return
	}

	utils.Info("UpdateLevel - Success: UserID=%v", userID)
	c.JSON(http.StatusOK, user)
}

// UpdateStats 更新学习统计
// PUT /api/user/stats
func UpdateStats(c *gin.Context) {
	userID, exists := c.Get("userID")
	if !exists {
		utils.Warn("UpdateStats - User not authenticated")
		c.JSON(http.StatusUnauthorized, gin.H{"error": "未授权"})
		return
	}

	var stats models.UserStats
	if err := c.ShouldBindJSON(&stats); err != nil {
		utils.Warn("UpdateStats - Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	utils.Info("UpdateStats - UserID: %v, Stats: %+v", userID, stats)

	var user models.User
	if err := database.GetDB().First(&user, userID).Error; err != nil {
		utils.Error("UpdateStats - User not found: %v", userID)
		c.JSON(http.StatusNotFound, gin.H{"error": "用户不存在"})
		return
	}

	user.Stats = stats
	if err := database.GetDB().Save(&user).Error; err != nil {
		utils.Error("UpdateStats - Update failed: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "更新失败"})
		return
	}

	utils.Info("UpdateStats - Success: UserID=%v", userID)
	c.JSON(http.StatusOK, user)
}
