retrieve_clauses <- function(original){

short <- strsplit(original, "依照《|据此，《|适用《|依据《|根据《|之规定|的规定")[[1]][2]

df <- data.frame(strsplit(short, "，|、|第|》|及|以及|《|【|】")[[1]])
colnames(df) <- "laws"
df$laws <- as.character(df$laws)
df$levels <- ""
df <- df[which(df$laws!=""),1:2]
df <- df[which(grepl("法|意见|通则|解释|条|款|一|二|三|四|五|六|七|八|九|十|最高人民法院|最高人民检察院|公安部|司法部",
                     df$laws)==TRUE),]

for (i in 1:nrow(df)){
  if (grepl("法|意见|通则|解释|条|款", df[i,1])==FALSE & 
      grepl("一|二|三|四|五|六|七|八|九|十", df[i,1]==TRUE)){
    df[i,1] <- paste0(df[i,1], "款")
  }
}
  
df[nrow(df),2] <- "low"

for (i in 1:(nrow(df)-1)){
  if (grepl("法|意见|通则|解释|最高人民法院|最高人民检察院|公安部|司法部", df[i,1])==TRUE){
    df[i,2] <- "high"
  } else if (grepl("款", df[i,1])==TRUE){
    df[i,2] <- "low"
  } else if (grepl("款", df[i+1,1])==TRUE){
    df[i,2] <- "mid"
  } else {
    df[i,2] <- "low"
  }
}

i <- 2

while (i>=2 & i<=nrow(df)){
  while (i-1>0 & df[i,2]=="high" & df[i-1,2]=="high"){
    df[i,1] <- paste0(df[i-1,1], df[i,1])
    df <- df[-(i-1),]
    i <- i-1
  }
  i <- i+1
}

temp <- data.frame(clause=character(0))
temp$clause <- as.character(temp$clause)
final <- temp


for (l in 1:nrow(df)){
  if (df[l,2]=="low"){
    low <- df[l,1]
    if (grepl("款", low)==TRUE & grepl("条", low)==FALSE){
      m <- l-1
      while (df[m,2]!="mid"){
        m <- m-1
      }
      mid <- df[m,1]
      h <- m-1
      while (df[h,2]!="high"){
        h <- h-1
      }
      high <- df[h,1]
      temp[1,1] <- paste0(high, mid, low)
      final <- rbind(final, temp)
    } else {
      h <- l-1
      while(df[h,2]!="high"){
        h <- h-1
      }
      high <- df[h,1]
      temp[1,1] <- paste0(high, low)
      final <- rbind(final, temp)
    }
  }
}

return(final)
}