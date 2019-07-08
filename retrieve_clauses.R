retrieve_clauses <- function(original){

short <- strsplit(original, "���ա�|�ݴˣ���|���á�|���ݡ�|���ݡ�|֮�涨|�Ĺ涨")[[1]][2]

df <- data.frame(strsplit(short, "��|��|��|��|��|�Լ�|��|��|��")[[1]])
colnames(df) <- "laws"
df$laws <- as.character(df$laws)
df$levels <- ""
df <- df[which(df$laws!=""),1:2]
df <- df[which(grepl("��|���|ͨ��|����|��|��|һ|��|��|��|��|��|��|��|��|ʮ|�������Ժ|���������Ժ|������|˾����",
                     df$laws)==TRUE),]

for (i in 1:nrow(df)){
  if (grepl("��|���|ͨ��|����|��|��", df[i,1])==FALSE & 
      grepl("һ|��|��|��|��|��|��|��|��|ʮ", df[i,1]==TRUE)){
    df[i,1] <- paste0(df[i,1], "��")
  }
}
  
df[nrow(df),2] <- "low"

for (i in 1:(nrow(df)-1)){
  if (grepl("��|���|ͨ��|����|�������Ժ|���������Ժ|������|˾����", df[i,1])==TRUE){
    df[i,2] <- "high"
  } else if (grepl("��", df[i,1])==TRUE){
    df[i,2] <- "low"
  } else if (grepl("��", df[i+1,1])==TRUE){
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
    if (grepl("��", low)==TRUE & grepl("��", low)==FALSE){
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