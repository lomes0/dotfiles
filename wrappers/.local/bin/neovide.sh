neovide &
neovide_pid=$!

while true ; do
	neovide_id=$(xdotool search --pid ${neovide_pid})
	if [ "${neovide_id}" != "" ] ; then
		xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id ${neovide_id}
		break;
	fi
	sleep 0.01
done
