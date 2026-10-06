FROM debian:bookworm-slim

# 时区
ENV TZ=Asia/Shanghai

# 关键：RUN 阶段指定 LC_ALL=C，防止 apt 安装时报 locale 缺失警告
RUN export DEBIAN_FRONTEND=noninteractive \
    export LC_ALL=C \
    && apt-get update \
    && apt-get install -y --no-install-recommends locales tzdata \
    && sed -i '/zh_CN.UTF-8 UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*

# 生成完成后，再设置容器运行时的中文环境变量
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8
