BEGIN{tcp=0;udp=0;ack=0;tdrop=0;udrop=0}
{
if ($1 =="r" && $5 == "cbr")
{
	ack++;
}
else if ($1=="d" && $5=="cbr")
{
        tdrop++;
}
}
END{
printf("Number of packets sent by UDP = %d \n",ack);
printf("Number of packets droped = %d \n",tdrop);
}
