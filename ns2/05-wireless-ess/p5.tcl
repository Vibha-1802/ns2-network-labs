# p5_fixed.tcl - Simple wireless example (4 mobile nodes, two TCP flows)
set ns [new Simulator]

# trace & nam
set tf [open wireless.tr w]
$ns trace-all $tf

set topo [new Topography]
$topo load_flatgrid 700 700

set nf [open wireless.nam w]
$ns namtrace-all-wireless $nf 700 700

# --- common wireless class names (use these exact strings) ---
set LL        LL
set IFQ       Queue/DropTail
set MAC       Mac/802_11
set PHY       Phy/WirelessPhy
set CHANNEL   Channel/WirelessChannel
set PROP      Propagation/TwoRayGround
set ANT       Antenna/OmniAntenna

# node-config: use correct flag names & values
$ns node-config \
    -adhocRouting DSDV \
    -llType $LL \
    -ifqType $IFQ \
    -ifqLen 50 \
    -macType $MAC \
    -phyType $PHY \
    -channelType $CHANNEL \
    -propType $PROP \
    -antType $ANT \
    -topoInstance $topo \
    -agentTrace ON \
    -routerTrace ON

# create-god must be invoked as shown
create-god 4

# create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# labels
$n0 label "tcp0"
$n1 label "sink1"
$n2 label "tcp1"
$n3 label "sink2"

# initial positions
$n0 set X_ 50;  $n0 set Y_ 50;  $n0 set Z_ 0
$n1 set X_ 200; $n1 set Y_ 200; $n1 set Z_ 0
$n2 set X_ 400; $n2 set Y_ 400; $n2 set Z_ 0
$n3 set X_ 600; $n3 set Y_ 600; $n3 set Z_ 0

# schedule small initial movement (optional)
$ns at 0.1 "$n0 setdest 60 60 10"
$ns at 0.1 "$n1 setdest 210 200 10"
$ns at 0.1 "$n2 setdest 410 410 10"
$ns at 0.1 "$n3 setdest 610 610 10"

# --- TCP flows ---
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns connect $tcp0 $sink1

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1
set sink2 [new Agent/TCPSink]
$ns attach-agent $n3 $sink2
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns connect $tcp1 $sink2

# schedule starts
$ns at 5.0 "$ftp0 start"
$ns at 10.0 "$ftp1 start"

# later movement (optional)
$ns at 100.0 "$n2 setdest 500 500 15"

proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $tf
    close $nf
    # exec nam wireless.nam &    ;# uncomment if NAM/display works for you
    exit 0
}
$ns at 250.0 "finish"

$ns run

