'''
Created on May 4, 2013

@author: "David Lai"
'''
from google.appengine.api import memcache
from models import StudentModel
import json
import uuid
import webapp2

class StudentLoginHandler(webapp2.RequestHandler):
    def debug(self, msg): 
        self.response.out.write(msg + "<br/>")
    def api_fail(self):
        self.response.out.write(json.dumps({'api': 'fail'}))

    def get(self):
        self.post()

    def post(self):
        self.response.headers['Content-Type'] = 'application/json' 
        action = self.request.get("action")

        if action == "login":
            username = self.request.get('username') 
            password = self.request.get('password')

            self._handle_login(username=username, password=password)
 
        
        elif action == "logout":
            student_token = self.request.get('token')
            memcache.delete(student_token, namespace="students")
            self.response.write(json.dumps({'api':'ok'}))

        elif action == "register":
            self._handle_register()


        elif action == "debug":
            try:
                student_token = self.request.get('token')
                self.response.out.write("token " + student_token)
                student = memcache.get(student_token, "students")
                self.response.out.write(json.dumps(student))
                self.response.out.write("end")
            except:
                self.response.out.write("not logged in")
            pass
        else:
            raise RuntimeError("invalid request error.")



    def _handle_register(self):
        student_model = StudentModel()
        student_model.first_name=self.request.get('firstName')
        student_model.middle_name=self.request.get('middleName')
        student_model.last_name=self.request.get('lastName')
        student_model.username=self.request.get('username')
        student_model.password=self.request.get('password')
        student_model.email=self.request.get('email')
        student_model.phone=self.request.get('phone')
        student_model.student_class=self.request.get('studentClass')

        student_model.put()

        self._handle_login(model=student_model)
 
    def _handle_login(self, username=None, password=None, model=None):
        "generate auth token and register session."
        if (username is None and password is None) and model is None:
            self.api_fail()
            return

        # Generate session token
        student_token = uuid.uuid1().bytes.encode('base64')\
        .rstrip('=\n').replace('/', '_').replace('+', "P")
        
        if model is not None:
            student_dict = model.get_dict()
        else:
            try:
                student = StudentModel.all().filter("username =", username)\
                .filter("password =", password).get()
                student_dict = student.get_dict()

            except:
                self.response.out.write(json.dumps({'api':'fail',
                                                    'reason':'invalid username/pass'
                                                    }))
                return #FAIL

        # add token and sudent info into memcache map.
        memcache.add(student_token, student_dict, 60*60*2, namespace="students")

        resp = {'api':'ok',
                'student':student_dict,
                'token':student_token }

        self.response.out.write(json.dumps(resp))
