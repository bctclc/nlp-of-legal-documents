# NLP of legal documents
Tool (hopefully tools) used to analyze somewhat formatted legal documents downloaded from http://openlaw.cn/

用来分析["OpenLaw"](http://openlaw.cn/)上下载得到的法律文书的R语言工具

-------------------------------------------------------------
## 从“判决结果”一栏提取判决所引用的法条

使用说明：将“retrieve_clauses.R”下载到工作路径里即可

#### 例1：单个使用

>library(stringr)

>source("retrieve_clauses.R")

>result <- "依照《中华人民共和国刑法》第三百五十九条第一款、第六十七条第三款、第五十三条的规定，判决如下:、被告人倪某某犯容留、介绍卖淫罪，判处有期徒刑一年六个月，并处罚金5000元。、（刑期从判决执行之日起计算。、判决执行以前先行羁押的，羁押一日折抵刑期一日，即自2015年3月4日起至2016年9月3日止。、罚金自判决生效后一个月内一次性向本院交纳，上缴国库。"

>retrieve_clauses(result)

    clause 

1 中华人民共和国刑法三百五十九条一款

2     中华人民共和国刑法六十七条三款

3         中华人民共和国刑法五十三条

#### 例2：批量使用

>library(stringr)

>source("retrieve_clauses.R")

>clauses <- data.frame(clause=character(0))  #建一个用来储存结果的数据框

>clauses$clause <- as.character(clauses$clause)

>for (i in 1:nrow(file)){                      #file改成法律文书所在的数据框对象名

  >if (file[i,4]!=""){                         #4改成“判决结果”所在的那一列
  
   >temp <- retrieve_clauses(file[i,4])
    
   >clauses <- rbind(clauses, temp)
    
  >}
  
>}
