from flask import Flask
from flask import render_template

import asyncore
import smtpd
import time
import os
import thread
import re

DIR = '/tmp/devpo'
if not os.path.isdir(DIR): os.makedirs(DIR)

# smtpd ----------------------------------------------------------------------

class DevelopmentSMTPServer(smtpd.SMTPServer):
  def process_message(self, peer, mailfrom, rcpttos, data):
    with open("%s/%s.txt" % (DIR, time.time()), 'w') as f:
      f.write(data)

def run_smtpd():
  srv = DevelopmentSMTPServer(('127.0.0.1', 2525), None)
  asyncore.loop()

# httpd ----------------------------------------------------------------------

def htmlize(s):
  return re.sub(r'\n', r'<br>',
         re.sub(r'(https?://[\w./?&#%+:]+)', r'<a href="\1">\1</a>', s))

app = Flask(__name__)

@app.route('/')
def index():
  mails = sorted(os.listdir(DIR))
  return render_template('index.html', mails=mails)

@app.route('/<id>')
def mail(id):
  with open("%s/%s" % (DIR, id), 'rb') as f:
    return htmlize(f.read())

if __name__ == '__main__':
  thread.start_new_thread(run_smtpd, ())
  app.run(host='0.0.0.0')
