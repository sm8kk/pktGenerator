#kill the pktgen constant traffic generator
kill -9 $(ps -aux | grep -v "grep" | grep "./pktGenUDPbg.sh" | awk '{print $2}')
echo "pktgen stopped..."
