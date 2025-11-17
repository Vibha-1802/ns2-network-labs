# Initialization, Create a ns simulator
set ns [new Simulator]
# Open the NS trace file
set tf [open p2.tr w]
$ns trace-all $tf
# Open the NAM trace file
set nf [open p2.nam w]
$ns namtrace-all $nf

# The below code is used to create the nodes.
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
# The below code is used to give color and label the nodes.
$ns color 1 "red"
$ns color 2 "blue"
$n0 label "Source/TCP"
$n1 label "Source/UDP"
$n2 label "Router"
$n3 label "Destination"
# Providing the link
$ns duplex-link $n0 $n2 100Mb 1ms DropTail #Change
$ns duplex-link $n1 $n2 100Mb 1ms DropTail #Change
$ns duplex-link $n2 $n3 100Mb 1ms DropTail
# Agent & Application Definition of TCP Connection
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink3 [new Agent/TCPSink]
$ns attach-agent $n3 $sink3
# Agent & Application Definition of UDP Connection
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3
# The below code is used to set the packet size and interval size of packets
$ftp0 set packetSize_ 500Mb
$ftp0 set interval_ 0.01 #Change
$cbr1 set packetSize_ 500Mb
$cbr1 set interval_ 0.01 #Change

# To set color to packets
$tcp0 set class_ 1
$udp1 set class_ 2
# The below code is used to connect the agents
$ns connect $tcp0 $sink3
$ns connect $udp1 $null3
# Termination defining a ‘finish’ procedure
proc finish {} {
global ns nf tf
$ns flush-trace
exec nam p2.nam &
close $nf
close $tf
exit 0
}
$ns at 0.1 "$cbr1 start"
$ns at 0.2 "$ftp0 start"
$ns at 9.5 "$cbr1 stop"
$ns at 10.0 "finish"
$ns run
