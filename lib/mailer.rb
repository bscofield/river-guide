require 'mail'

class Mailer
  def self.send(new_drops, drops, books)
    set_defaults
    now = Time.now.strftime('%-d %B')

    message = ''

    message += '<strong>PRICE DROPS</strong><br>'+
                new_drops.map(&:to_screen).join('<br>') + '<br><br>'
    message += '<strong>DISCOUNTED</strong><br>' +
                drops.map(&:to_screen).join('<br>') + '<br><br>'
    message += '<strong>ALL OTHERS</strong><br>' +
                books.map(&:to_screen).join('<br>')

    Mail.deliver do
      to        ENV['RECIPIENT']
      from     'river-guide@example.com'
      subject  'River Guide for ' + now

      html_part do
        content_type 'text/html; charset=UTF-8'
        body          message
      end
    end
  end

  def self.set_defaults
    Mail.defaults do
      delivery_method :smtp, {
        domain:         'example.com',
        port:            ENV['MAILGUN_SMTP_PORT'],
        address:         ENV['MAILGUN_SMTP_SERVER'],
        user_name:       ENV['MAILGUN_SMTP_LOGIN'],
        password:        ENV['MAILGUN_SMTP_PASSWORD'],
        authentication: :plain
      }
    end
  end
end
