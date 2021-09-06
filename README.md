# RailsExtend
Rails 通用基础库，对 Rails 的各个组件进行了扩展。

## 功能模块
* Ruby 核心类扩展，[链接](lib/rails_extend/core)
* Rails 核心类扩展
  * ActiveStorage：[链接](lib/rails_com/active_storage) 
    * 通过 url 同步文件；
    * 将文件复制到镜像服务器；
* Rails 元信息: 
  * [Model](lib/rails_extend/models.rb)
  * [Routes / Controllers](lib/rails_extend/routes)

## 支持 enum
```yaml
# zh.yml
activerecord:
  enum:
    notification:
      receiver_type:
        User: 全体用户
        Member: 成员
```

```ruby
t.select :receiver_type, options_for_select(Notification.options_i18n(:receiver_type))
```

* Override
```yaml
activerecord:
  enum:
    notification:
      receiver_type:
        User: 全体用户
        Member: # remain this blank
```


## 版权
遵循 [MIT](https://opensource.org/licenses/MIT) 协议
