package models

import (
	"time"

	"gorm.io/gorm"
)

// User 用户模型
// 使用 gorm.Model 包含 ID, CreatedAt, UpdatedAt, DeletedAt 字段
type User struct {
	gorm.Model
	Username string    `gorm:"uniqueIndex;not null" json:"username"`        // 用户名，唯一索引
	Password string    `gorm:"not null" json:"-"`                           // 密码，不返回给前端
	Name     string    `json:"name"`                                        // 昵称
	Level    UserLevel `gorm:"embedded;embeddedPrefix:level_" json:"level"` // 用户等级信息
	Stats    UserStats `gorm:"embedded;embeddedPrefix:stats_" json:"stats"` // 学习统计数据
}

// UserLevel 用户等级信息
// 包含词汇、听力、口语三个维度的等级和分数
type UserLevel struct {
	VocabularyLevel string `json:"vocabulary_level"` // 词汇等级 (A1-C2)
	VocabularyScore int    `json:"vocabulary_score"` // 词汇分数 (0-100)
	ListeningLevel  string `json:"listening_level"`  // 听力等级
	ListeningScore  int    `json:"listening_score"`  // 听力分数
	SpeakingLevel   string `json:"speaking_level"`   // 口语等级
	SpeakingScore   int    `json:"speaking_score"`   // 口语分数
	OverallLevel    string `json:"overall_level"`    // 综合等级
}

// UserStats 学习统计数据
// 记录用户的学习天数、连续学习天数、学习时长等
type UserStats struct {
	TotalStudyDays        int        `json:"total_study_days"`        // 累计学习天数
	CurrentStreak         int        `json:"current_streak"`          // 当前连续学习天数
	TotalWordsLearned     int        `json:"total_words_learned"`     // 已学单词总数
	TotalListeningMinutes int        `json:"total_listening_minutes"` // 累计听力练习分钟数
	TotalSpeakingMinutes  int        `json:"total_speaking_minutes"`  // 累计口语练习分钟数
	LastStudyDate         *time.Time `json:"last_study_date"`         // 上次学习日期
}

// TableName 指定数据库表名
func (User) TableName() string {
	return "users"
}

// GetDefaultLevel 返回默认等级信息
func GetDefaultLevel() UserLevel {
	return UserLevel{
		VocabularyLevel: "A1",
		VocabularyScore: 0,
		ListeningLevel:  "A1",
		ListeningScore:  0,
		SpeakingLevel:   "A1",
		SpeakingScore:   0,
		OverallLevel:    "A1",
	}
}

// GetDefaultStats 返回默认统计数据
func GetDefaultStats() UserStats {
	return UserStats{
		TotalStudyDays:        0,
		CurrentStreak:         0,
		TotalWordsLearned:     0,
		TotalListeningMinutes: 0,
		TotalSpeakingMinutes:  0,
		LastStudyDate:         nil,
	}
}
