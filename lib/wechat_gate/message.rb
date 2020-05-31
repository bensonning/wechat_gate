module WechatGate
  module Message
    #
    # http://mp.weixin.qq.com/wiki/17/f298879f8fb29ab98b2f2971d42552fd.html
    #
    # 消息发送只能是被动的，就是微信会把用户的聊天数据推送到服务器端，然后服务器利用返回值作出相应
    #

    def message_body(type, to, body)
      content = case type.to_sym
      when :text
        %Q{
          <Content><![CDATA[#{body}]]></Content>
        }
      when :image
        # body: media_id
        %Q{
          <Image>
            <MediaId><![CDATA[#{body}]]></MediaId>
          </Image>
        }
      when :voice
        %Q{
          <Voice>
            <MediaId><![CDATA[#{body}]]></MediaId>
          </Voice>
        }
      when :news
        %Q{
         <ArticleCount>#{body[:count]}</ArticleCount>
          <Articles>
            <item>
              <Title><![CDATA[#{body[:title]}]]></Title>
              <Description><![CDATA[#{body[:description]}]]></Description>
              <PicUrl><![CDATA[#{body[:picurl]}]]></PicUrl>
              <Url><![CDATA[#{body[:url]}]]></Url>
            </item>
          </Articles>
        }
      when :video
        # body: { media_id: MEDIA_ID, title: TITLE, description: DESCRIPTION }
        %Q{
          <Video>
            <MediaId><![CDATA[#{body[:media_id]}]]></MediaId>
            <Title><![CDATA[#{body[:title]}]]></Title>
            <Description><![CDATA[#{body[:description]}]]></Description>
          </Video>
        }
      end

      %Q{
        <xml>
          <ToUserName><![CDATA[#{to}]]></ToUserName>
          <FromUserName><![CDATA[#{self.config['wechat_id']}]]></FromUserName>
          <CreateTime>#{Time.now.to_i}</CreateTime>
          <MsgType><![CDATA[#{type}]]></MsgType>
          #{content}
        </xml>
      }
    end

  end


end
