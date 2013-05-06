#!/usr/bin/env python
import webapp2
from student import StudentLoginHandler
from teacher import TeacherLoginHandler
from question_queue import QuestionQueueHandler
from chat import ChatHandler
from notifications import NotificationHandler





class MainHandler(webapp2.RequestHandler):

    def get(self):
        self.response.write('Hello world!')





app = webapp2.WSGIApplication([
    ('/', MainHandler),
    ('/auth', StudentLoginHandler),
    ('/teacherauth', TeacherLoginHandler),
    ('/questions', QuestionQueueHandler),
    ('/chat', ChatHandler),
    ('/tasks/notification', NotificationHandler)
], debug=True)
