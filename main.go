package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {
	timeZone := os.Getenv("TIMEZONE")
	env := os.Getenv("ENV")

	// 输出当前时间
	log.Printf("------ 环境：ENV:%s 时区：TIMEZONE:%s 当前时间：CurrentTime %s\n", env, timeZone, time.Now().Format(time.RFC3339))

	fmt.Println("success")

	e := gin.Default() //创建一个默认的路由引擎
	e.GET("/hello", Hello)
	e.Run("0.0.0.0:9002")
}

func Hello(c *gin.Context) {
	c.String(200, "hello %s", "world")
	c.JSON(http.StatusOK, gin.H{ //以json格式输出
		"name": "tom",
		"age":  "20",
	}) //200代表请求成功,http.StatusOK代表请求成功,gin.H是map的一个快捷方式
}
