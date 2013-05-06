from google.appengine.ext import db
import json
import time


class ChatModel(db.Model):
    "Chat messages"
    chat_channel = db.StringProperty()
    sender = db.StringProperty()
    message = db.StringProperty(multiline=True)
    time_stamp = db.DateTimeProperty(auto_now=True)

    def get_json(self):
        
        return json.dump(self.get_dict())

    def get_dict(self):
        props = {'id':self.key().id(),
                 'channel':self.chat_channel,
                 'sender':self.sender,
                 'message':self.message,
                 'timeStamp':long(time.mktime(self.time_stamp.timetuple()))
        }
        return props




class StudentModel(db.Model):
    "Student information DB Model"
    first_name = db.StringProperty()
    middle_Nname = db.StringProperty()
    last_name = db.StringProperty()
    username = db.StringProperty()
    password = db.StringProperty()
    email = db.StringProperty()
    phone = db.StringProperty()
    student_class = db.StringProperty()

    def get_json(self):
        
        return json.dump(self.get_dict())

    def get_dict(self):
        props = {'id':self.key().id(),
                 'firstName':self.first_name,
                 'middleName':self.middle_Nname,
                 'lastName':self.last_name,
                 'username':self.username,
                 'pasword':self.password,
                 'email':self.email,
                 'phone':self.phone,
                 'studentClass':self.student_class
        }
        return props


class StudentQuestionModel(db.Model):
    student = db.Reference(StudentModel)
    question_text = db.StringProperty
    status = db.Property(default='unanswered', 
                         choices=['unanswered', 'notified', 'answered'])
    notification_type = db.Property(default='none', choices=['none', 'email', 'sms'])
    time_stamp = db.DateTimeProperty(auto_now=True)

    def get_json(self):
        return json.dump(self.get_dict())

    def get_dict(self):
        props = {'id':self.key().id(),
                 'student':self.student.get_dict(),
                 'questionText':self.question_text,
                 'status':self.status,
                 'notifyType':self.notification_type,
                 'timeStamp': long(time.mktime(self.time_stamp.timetuple()))
        }
        return props



class TeacherModel(db.Model):
    "Student information DB Model"
    first_name = db.StringProperty()
    middle_Nname = db.StringProperty()
    last_name = db.StringProperty()
    username = db.StringProperty()
    password = db.StringProperty()
    email = db.StringProperty()
    phone = db.StringProperty()

    def get_json(self):
        return json.dump(self.get_dict())

    def get_dict(self):
        props = {'id':self.key().id(),
                 'firstName':self.first_name,
                 'middleName':self.middle_Nname,
                 'lastName':self.last_name,
                 'username':self.username,
                 'pasword':self.password,
                 'email':self.email,
                 'phone':self.phone,
        }
        return props
