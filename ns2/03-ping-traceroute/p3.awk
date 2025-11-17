BEGIN{
count=0;
}
{
if($1=="d")
count++;
}
END{
printf("The total no of packets dropped due to congestion %d\n",count);
}

