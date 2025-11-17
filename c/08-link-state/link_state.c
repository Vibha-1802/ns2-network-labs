#include<stdio.h>
void dij(int n,int cost[10][10],int source,int dest,int d[],int p[])
{
int i,j,u,v,min,s[10];
for(i=0;i<n;i++)
{
d[i]=cost[source][i];
s[i]=0;
p[i]=source;
}
s[source]=1;
for(i=1;i<n;i++)
{
min=999;
u=-1;
for(j=0;j<n;j++)
{
if(s[j]==0)
{
if(d[j]<min)
{
min=d[j];
u=j;
}
}
}
if(u==-1)
return;
s[u]=1;
if(u==dest)
return;
for(v=0;v<n;v++)
{
if(s[v]==0)

{
if(d[u]+cost[u][v]<d[v])
{
d[v]=d[u]+cost[u][v];
p[v]=u;
}
}
}
}
}
void print_path(int source,int destination,int d[],int p[])
{
int i;
i=destination;
while(i!=source)
{
printf("%d<-",i);
i=p[i];
}
printf("%d=%d\n",i,d[destination]);
}
int main()
{
int cost[10][10],n,d[10],p[10],i,j;
printf("Enter the number of nodes in the network\n");
scanf("%d",&n);
printf("Enter the cost n between every nodes\n");
for(i=0;i<n;i++)
for(j=0;j<n;j++)
scanf("%d",&cost[i][j]);
printf("enter the source node\n");
scanf("%d",&i);
for(j=0;j<n;j++)
{
dij(n,cost,i,j,d,p);
if(d[j]==999)
printf("%d is not reachable from %d\n",j,i);
else if(i!=j)
print_path(i,j,d,p);
}

return 0;
}