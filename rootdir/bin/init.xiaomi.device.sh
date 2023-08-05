#!/vendor/bin/sh

set_acdb_path_props() {
	i=0
	for f in `ls /vendor/etc/acdbdata/${1}/*.*`; do
		setprop "persist.vendor.audio.calfile${i}" "${f}"
		let i+=1
	done
}

case "$(cat /sys/motorola-msm8937-mach/variant)" in
	"ahannah")
		# Audio ACDB
		typeset -l carrier=$(getprop ro.carrier)

		latam="timbr tefbr amxbr retbr"

		if echo "${latam[@]}" | grep -w "$carrier" &>/dev/null; then
			# use audio parameter specialized for latam market
			set_acdb_path_props ahannah_bl
		elif [ $carrier == "retid" ]; then
			# use audio parameter specialized for indonesia
			set_acdb_path_props ahannah_id
		else
			# use default audio parameter
			set_acdb_path_props ahannah
		fi
		# Audio fluence
		setprop persist.audio.fluence.voicecall true
		setprop persist.audio.fluence.voicecomm true
		setprop persist.audio.fluence.voicerec true
		setprop persist.audio.fluence.speaker false
		setprop ro.qc.sdk.audio.fluencetype fluence
		setprop vendor.audio.feature.fluence.enable true
		;;
	*)
		set_acdb_path_props "$(cat /sys/motorola-msm8937-mach/variant)"
		;;
esac

exit 0
