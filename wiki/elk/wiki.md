# Elasticsearch 介绍
ElasticSearch是一个基于Lucene的搜索服务器。它提供了一个分布式多用户能力的全文搜索引擎，基于RESTful web接口。Elasticsearch是用Java开发的，并作为Apache许可条款下的开放源码发布，是当前流行的企业级搜索引擎。设计用于云计算中，能够达到实时搜索，稳定，可靠，快速，安装使用方便。

# 相关链接
- https://www.elastic.co/
- https://www.elastic.co/downloads/marvel
- http://www.learnes.net/


# 起止命令
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
- 安装elasticsearch-head(已经不是Elasticsearch插件功能)

```
git clone git://github.com/mobz/elasticsearch-head.git
npm install(npm install -g cnpm --registry=https://registry.npm.taobao.org)

#通过命令执行
npm install -g grunt-cli
grunt server(nohop grunt server)


```


# Logstash 介绍

- https://www.elastic.co/products/logstash
- http://kibana.logstash.es/content/logstash/scale/redis.html

# 起止命令
```
bin/logstash-5.1.2/bin/logstash -f $DIR/bin/logstash-5.1.2/config/logstash.conf &


function stop_logstash(){

    logstash=$(ps -ef | grep logstash | sed -n '1,1p' | awk '{print $2}')
    echo $logstash
    kill -9 $logstash

}

stop_logstash

```


# 插件安装
```
bin/logstash-plugin list

bin/logstash-plugin install logstash-input-kafka
bin/logstash-plugin install logstash-output-kafka

bin/logstash-plugin install logstash-input-elasticsearch
bin/logstash-plugin install logstash-output-elasticsearch

bin/logstash-plugin install logstash-input-redis
bin/logstash-plugin install logstash-output-redis
```


# Kafka 介绍
Kafka是一种高吞吐量的分布式发布订阅消息系统，它可以处理消费者规模的网站中的所有动作流数据。 这种动作（网页浏览，搜索和其他用户的行动）是在现代网络上的许多社会功能的一个关键因素。 这些数据通常是由于吞吐量的要求而通过处理日志和日志聚合来解决。 对于像Hadoop的一样的日志数据和离线分析系统，但又要求实时处理的限制，这是一个可行的解决方案。Kafka的目的是通过Hadoop的并行加载机制来统一线上和离线的消息处理，也是为了通过集群来提供实时的消费

#相关链接
- https://cwiki.apache.org/confluence/display/KAFKA/A+Guide+To+The+Kafka+Protocol

# 起止命令
```

#启动
/usr/local/kafka/bin/zookeeper-server-start.sh \
/usr/local/kafka/config/zookeeper.properties &

/usr/local/kafka/bin/kafka-server-start.sh \
/usr/local/kafka/config/server.properties &


#停止
function stop_kafka(){

	kafka_pid2=$(ps -ef|grep kafka| sed -n '1,1p' | awk '{print $2}')
	echo $kafka_pid2
	kill -9 $kafka_pid2

	kafka_pid=$(ps ax | grep -i 'kafka\.Kafka' | grep java | grep -v grep | awk '{print $1}')
	kill -9 $kafka_pid

}


stop_kafka
```

# 其他命令
logstash --help --可以通过此命令看到所有命令
-f, --path.config －－配置文件路径
-e, --config.string －－可直接运行的配置字符串
-w, --pipeline.workers --处理线程数
-b, --pipeline.batch.size －－每个线程每次处理的大小

