# Introduction to Cloud IDE

## 修改密码

建议最开始修改密码。

修改`/root/.config/code-server/config.yaml` 文件，保存

```yaml=
bind-addr: 0.0.0.0:8080 # 不要修改
auth: password # 不要修改
password: speit # 改成新密码
cert: false # 不要修改
```

> 如果要使用纯数字密码，需要在密码外加上单引号，例如
> ```yaml
> bind-addr: 0.0.0.0:8080 # 不要修改
> auth: password # 不要修改
> password: '31415926535' # 改成新密码
> cert: false # 不要修改
> ```
> 强烈**不推荐**使用纯数字作为密码

输入`restart-container`，重启容器

> 重启容器将导致非`/root`路径下的内容丢失

## 额度限制

只有`/root`目录下的文件会被持久存储，但也仅限于本次课程的时段，因此不要在容器中存放珍贵文件。
