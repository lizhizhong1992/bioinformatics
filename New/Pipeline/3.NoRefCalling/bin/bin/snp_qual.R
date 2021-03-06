times<-Sys.time()
library('getopt')
library(ggplot2)
library(grid)
library(gplots)
options(bitmapType='cairo')

spec = matrix(c(
	'GQ','a',0,'character',
	'dep','b',0,'character',
	'o','c',0,'character',
	'sub','d',0,'logical',
	'par','e',0,'character',
	'help' , 'f', 0, 'logical'
	), byrow=TRUE, ncol=4);
opt = getopt(spec);
print_usage <- function(spec=NULL){
	cat(getopt(spec, usage=TRUE));
	cat("Usage example: \n")
	cat("
Usage example: 
	Rscript snp_qual.r --GQ  --dep  --o  
	
Usage:
	--dep	Cumulative depth
	--o	    figure name
	--help		usage
\n")
	q(status=1);
}

if ( !is.null(opt$help) ) { print_usage(spec) }
if ( is.null(opt$dep) ) { print_usage(spec) }
if ( is.null(opt$o) ) { print_usage(spec) }

old_theme <- theme_update(
  axis.ticks=element_line(colour="black"),
  panel.grid.major=element_blank(),
  panel.grid.minor=element_blank(),
  panel.background=element_blank(),
  panel.border=element_rect(fill="transparent", color="black"),
  axis.line=element_line(size=0.5),
  plot.title=element_text(hjust=0.5,size=10)
  
)

depth_in=read.table(opt$dep,header=T)
samples=unique(depth_in$sampleID);
print(samples)
for (i in samples){
	depth_sum=max(depth_in$num[depth_in$sampleID == i]);
	depth_in$frac[depth_in$sampleID == i]=depth_in$num[depth_in$sampleID == i]/depth_sum;
}
pdf(paste(opt$o,".pdf",sep=""))
p<-ggplot(depth_in,aes(x=Depth,y=frac))+geom_line(aes(colour=sampleID,group=sampleID))
p<-p+xlim(0,100)
p<-p+xlab("Depth")+ylab("SNP Fraction(%)")+ggtitle("Cumulative SNP depth distribution")
print(p)
dev.off();

png(paste(opt$o,".png",sep=""))
p<-ggplot(depth_in,aes(x=Depth,y=frac))+geom_line(aes(colour=sampleID,group=sampleID))
p<-p+xlim(0,100)
p<-p+xlab("Depth")+ylab("SNP Fraction(%)")+ggtitle("Cumulative SNP depth distribution")
print(p)
dev.off();
escaptime=Sys.time()-times;
print("Done!")
print(escaptime)
