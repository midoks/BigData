# Elasticsearch 介绍
ElasticSearch是一个基于Lucene的搜索服务器。它提供了一个分布式多用户能力的全文搜索引擎，基于RESTful web接口。Elasticsearch是用Java开发的，并作为Apache许可条款下的开放源码发布，是当前流行的企业级搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。

# 相关链接
- https://www.elastic.co/
- https://www.elastic.co/downloads/marvel
- http://www.learnes.net/


# 重要命令
- 启动 
elasticsearch -d
- 停止
```
function stop(){
	pid=$(ps -ef | grep elastic | sed -n "1,1p" | awk '{print $2}')
	kill -9 $pid
}
stop
```

#配置