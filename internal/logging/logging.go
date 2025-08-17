package logging

import (
	"fmt"
	"os"

	"log/slog"

	gblogger "github.com/ZanzyTHEbar/go-basetools/logger"
)

// InitFromEnv initializes logger using go-basetools logger package.
func InitFromEnv() {
	cfg := &gblogger.Config{}
	if v := os.Getenv("LOG_STYLE"); v != "" {
		cfg.Logger.Style = v
	} else {
		cfg.Logger.Style = "json"
	}
	if v := os.Getenv("LOG_LEVEL"); v != "" {
		cfg.Logger.Level = v
	} else {
		cfg.Logger.Level = "info"
	}
	gblogger.InitLogger(cfg)
	_ = slog.Default()
}

func Debugf(format string, v ...interface{}) { slog.Debug(fmt.Sprintf(format, v...)) }
func Infof(format string, v ...interface{})  { slog.Info(fmt.Sprintf(format, v...)) }
func Warnf(format string, v ...interface{})  { slog.Warn(fmt.Sprintf(format, v...)) }
func Errorf(format string, v ...interface{}) { slog.Error(fmt.Sprintf(format, v...)) }
func Fatalf(format string, v ...interface{}) { slog.Error(fmt.Sprintf(format, v...)); os.Exit(1) }
