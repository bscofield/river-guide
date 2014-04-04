require 'mail'

class Mailer
  def self.send(books)
    set_defaults
    now = Time.now.strftime('%-d %B')

    Mail.deliver do
      to        ENV['RECIPIENT']
      from     'river-guide@example.com'
      subject  'River Guide for ' + now

      html_part do
        content_type 'text/html; charset=UTF-8'
        body          books.map(&:to_s).join('<br>')
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
