#! /bin/bash

# 1番の引数取得
url=$1;

# URLになっているかを確認する
if [[ $url =~ (https?://[^/]+/) ]] && [[ `echo ${url} | grep amazon` ]]; then
    dirs=(`echo ${url} | tr -s '/' ' '`);
    protocol=$dirs[1];
    domain=$dirs[2];
    id="";
    is_valid_url="false";

    # 分割した文字列を処理する。
    for dir in $dirs[@]; do
        # dpがあったら処理を続行
        if [[ $dir =~ dp ]]; then
            is_valid_url="true";
            continue;
        fi
        
        # dpの次は商品ID
        if "${is_valid_url}"; then
            id=$dir;
            break;
        fi
    done;

    # 有効なURLかを最後に判断する
    if [[ -z "$id" ]] && [[ $is_valid_url =~ false ]]; then
        echo "Failed to parse.";
        return 1;
    fi

    echo "${protocol}//${domain}/dp/${id}";
    return 0;
else
    echo "Invalid amazon url.";
    return 1;
fi