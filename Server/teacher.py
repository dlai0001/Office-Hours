'''
Created on May 4, 2013

@author: "David Lai"
'''

from google.appengine.api import memcache
from models import TeacherModel
import json
import uuid
import webapp2




class TeacherLoginHandler(webapp2.RequestHandler):
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
            memcache.delete(student_token, namespace="teachers")
            self.response.write(json.dumps({'api':'ok'}))

        elif action == "register":
            self._handle_register()


        elif action == "debug":
            try:
                student_token = self.request.get('token')
                self.response.out.write("token " + student_token)
                student = memcache.get(student_token, "teachers")
                self.response.out.write(json.dumps(student))
                self.response.out.write("end")
            except:
                self.response.out.write("not logged in")
            pass
        else:
            raise RuntimeError("invalid request error.")



    def _handle_register(self):
        teacher_model = TeacherModel()
        teacher_model.first_name=self.request.get('firstName')
        teacher_model.middle_name=self.request.get('middleName')
        teacher_model.last_name=self.request.get('lastName')
        teacher_model.username=self.request.get('username')
        teacher_model.password=self.request.get('password')
        teacher_model.email=self.request.get('email')
        teacher_model.phone=self.request.get('phone')

        teacher_model.put()

        self._handle_login(model=teacher_model)
 
    def _handle_login(self, username=None, password=None, model=None):
        "generate auth token and register session."
        if (username is None and password is None) and model is None:
            self.api_fail()
            return

        # Generate session token
        teacher_token = uuid.uuid1().bytes.encode('base64')\
        .rstrip('=\n').replace('/', '_').replace('+', "P")
        
        if model is not None:
            teacher_dict = model.get_dict()
        else:
        

            try:
                teacher = TeacherModel.all().filter("username =", username)\
                .filter("password =", password).get()

                teacher_dict = teacher.get_dict()
            except:
                self.response.out.write(json.dumps({'api':'fail',
                                                    'reason':'invalid username/pass'
                                                    }))
                return #FAIL

        # add token and sudent info into memcache map.
        teacher_dict['token'] = teacher_token
        memcache.add(teacher_token, teacher_dict, 60*60*24, namespace="teachers")

        resp = {'api':'ok',
                'teacher':teacher_dict,
                'token':teacher_token }

        self.response.out.write(json.dumps(resp))


