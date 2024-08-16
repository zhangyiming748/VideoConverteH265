#!/bin/bash

# 指定文件夹路径
folder_path="/path/to/your/folder"

# 遍历文件夹下的所有文件
for file in "$folder_path"/*; do
    # 检查文件是否为视频文件
    if [[ $file =~ \.(mp4|avi|mkv|flv|mov)$ ]]; then
        # 获取视频编码信息
        encoding=$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$file")
        
        # 检查视频编码是否为h265
        if [[ $encoding != "hevc" ]]; then
            # 转换视频编码为h265
            output_file="${file%.*}_h265.${file##*.}"
            ffmpeg -i "$file" -c:v libx265 "$output_file"
            echo "Converted $file to $output_file"
        fi
    fi
done
