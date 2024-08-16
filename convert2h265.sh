#!/bin/bash

# 指定文件夹路径
folder_path="/path/to/your/folder"
# 打印开始时间
total_start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "开始时间: $total_start_time"
# 遍历文件夹下的所有文件
for file in "$folder_path"/*; do

	# 检查文件是否为视频文件
	if [[ $file =~ \.(mp4|avi|mkv|flv|mov)$ ]]; then

		# 获取视频编码信息
		encoding=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")

		# 检查视频编码是否为h265
		if [[ $encoding != "hevc" ]]; then
			# 打印开始时间
			start_time=$(date +"%Y-%m-%d %H:%M:%S")
			echo "开始时间: $start_time"

			# 转换视频编码为h265
			output_file="${file%.*}_h265.${file##*.}"
			ffmpeg -i "$file" -c:v libx265 "$output_file"

			# 打印结束时间
			end_time=$(date +"%Y-%m-%d %H:%M:%S")
			echo "结束时间: $end_time"
			echo "Converted $file to $output_file"

			# 计算并打印程序用时
			duration=$(($(date -d "$end_time" +%s) - $(date -d "$start_time" +%s)))
			echo "程序用时: $duration 秒"
		fi
	fi
done
# 打印结束时间
total_end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "结束时间: $total_end_time"

# 计算并打印程序用时
total_duration=$(($(date -d "$total_end_time" +%s) - $(date -d "$total_start_time" +%s)))
echo "程序用时: $total_duration 秒"
