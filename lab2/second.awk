BEGIN{tcp=0;udp=0}
{
if($1 == "r" && $5 == "tcp")
{
	tcp++;
}
else if($1 == "r" && $5 =="cbr")
{
	udp++;
}
}
END {
printf("Total number of packets sent by TCP : %d\n",tcp);
printf("Total number of packets sent by UDP : %d\n",udp); 
}
