'''
Created on May 5, 2013

@author: "David Lai"
'''
import webapp2
from models import StudentQuestionModel
from google.appengine.api import mail, urlfetch
import urllib
import base64

class NotificationHandler(webapp2.RequestHandler):
    def get(self):
        print "cron job run"
        
        student_questions = StudentQuestionModel.all().order("time_stamp")
        print "student query succeeded"
        try:
            print "first question", student_questions[0].status
            print "first question", student_questions[0].notification_type
            if student_questions[0].status != 'notified' \
            and student_questions[0].status != 'answered':
                if student_questions[0].notification_type == 'email':
                    self.send_email(student_questions[0].student.email, 
                                    "Your are next in line.", 
                                    """TODO redirect URL to app.  
                                  You are currently first in line.
                                  Please open your office hours app.""")
                elif student_questions[0].notification_type == 'sms':
                    phone = student_questions[0].student.phone
                    self.send_sms(phone, 
                                  "TODO redirect URL to app. You are currently first in line.")
                # mark notified.
                print "setting status notified."
                student_questions[0].status = 'notified'
                student_questions[0].put()
        except:
            pass
        
    
    def send_email(self, email, subject, message):
        mail.send_mail("virtualofficeassistant@example.com", 
                       email, subject, message)
    
    def send_sms(self, phone, message):
        print "sending sms"
        form_fields = {
          "From": "+18054914545",
          "To": "8053380996",
          "Body": message
        }
        form_data = urllib.urlencode(form_fields)
                
        result = urlfetch.fetch(url="https://api.twilio.com/2010-04-01/Accounts/TWILIOACCTKEY/SMS/Messages.json",
                        payload=form_data,
                        method=urlfetch.POST,
                        headers={"Authorization": 
                                 "Basic %s" % base64.b64encode("TWILIOACCTKEY:TWILIOAPIPASSKEY")
                        }
        )
        print result.content

