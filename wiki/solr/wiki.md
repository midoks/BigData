# Solr服务
Solr是一个独立的企业级搜索应用服务器，它对外提供类似于Web-service的API接口。用户可以通过http请求，向搜索引擎服务器提交一定格式的XML文件，生成索引；也可以通过Http Get操作提出查找请求，并得到XML(及其他格式)的返回结果。

# 相关文档
- http://www.apache.org/dyn/closer.lua/lucene/solr/6.3.0
- https://lucene.apache.org/solr/resources.html#tutorials
- http://dev.mysql.com/downloads/connector/j/
- https://wiki.apache.org/solr/DataImportHandler

#安装solr准备工作
* JAVA环境安装
* windows -> solr-6.3.0.zip
* Unix,Linux,MacOSX -> solr-6.3.0.tgz

# 常用命令
* bin/solr start
* bin/solr stop
* bin/solr restart

# 配置
- 复制solrconfig.xml文件(server/solr/configsets/basic_configs/conf)
在
```
<requestHandler name="/dataimport" class="solr.DataImportHandler">  
     <lst name="defaults">  
        <str name="config">db-data-config.xml</str>  
     </lst>  
</requestHandler>
```


#8小时时差问题(bin/solr.in.sh)
SOLR_TIMEZONE="UTC+8"







