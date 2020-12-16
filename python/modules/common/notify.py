'''Module for sending email notifications.'''

from email.message import EmailMessage
from email.mime.text import MIMEText
import smtplib
import ssl


def notify(subject='', body='', attachment=''):
    host = 'mail.server.com'
    port = 587
    sender = 'your-email@server.com'
    receiver = 'your-email@server.com'
    password = 'XXXX'
    message = EmailMessage()
    message["From"] = sender
    message["To"] = receiver
    message["Subject"] = subject

    if attachment:
        with open(attachment) as a:
            message.set_content(body + '\n' * 2 + a.read())
    elif body:
        message.set_content(body + '\n' * 2)

    text = message.as_string()

    context = ssl.create_default_context()

    try:
        server = smtplib.SMTP(host, port)
        server.starttls(context=context)
        server.login(sender, password)
        server.sendmail(sender, receiver, text)
    except Exception as e:
        print(e)
    finally:
        server.quit()
