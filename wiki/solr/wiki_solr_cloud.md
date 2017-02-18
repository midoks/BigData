# Solr单机tomcat搭建(mac)

- http://tomcat.apache.org/whichversion.html
- http://lucene.apache.org/solr/


# 方法步骤
- 解压Tomcat到一个目录,例如/Users/midoks/Desktop/solr_cloud/apache-tomcat-7.0.75

- 将solr压缩包中solr-6.3.0中的server/solr-webapp/文件夹下有个webapp文件夹,将之复制到Tomcat/webapps/目录下,并改成solr(名字随意)

- 将solr压缩包中solr-6.3.0中server/lib/ext中的jar全部复制到Tomcat/webapps/solr/WEB-INF/lib目录中

- 将solr压缩包中solr-6.3.0中server/resources/log4j.properties复制到Tomcat/webapps/solr/WEB-INF/classes 目录中（如果没有classes则创建

- 将solr压缩包中solr-6.3.0中server/solr目录复制到计算机某个目录下,如/Users/midoks/Desktop/solr_cloud/solr

- 打开Tomcat/webapps/solr/WEB-INF下的web.xml，找到如下配置内容(初始状态下该内容是被注释掉的)
```
<env-entry>
       <env-entry-name>solr_home</env-entry-name>
       <env-entry-value>/put/your/solr/home/here</env-entry-value>
       <env-entry-type>java.lang.String</env-entry-type>
</env-entry>
将<env-entry-value>中的内容改成你的solr/home路径，这里是/Users/midoks/Desktop/solr_cloud/solr
```

- 打开Tomcat/webapps/solr/WEB-INF下的web.xml修改项目欢迎页面
```
<welcome-file-list>
<welcome-file>./index.html</welcome-file>
</welcome-file-list>
```

- 还需要添加solr-dataimporthandler-solr-6.3.0.jar和solr-dataimporthandler-extras-solr-6.3.0.jar这2个jar包到目录tomcat/webapps/solr/WEB-INF/lib/下,否则会报错,这2个包默认不在webapp里,在下载包的dist目录下.

- 保存关闭，而后启动tomcat，在浏览器输入http://localhost:8080/solr即可出现Solr的管理界面


# Solr集群搭建

- http://zookeeper.apache.org/releases.html#download
