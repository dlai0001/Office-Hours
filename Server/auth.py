'''
Created on May 4, 2013

@author: "David Lai"
'''
from google.appengine.api import memcache



def get_student(student_token):
    try:
        student = memcache.get(student_token, "students")
        if student is None:
            raise RuntimeError("Invalid token")
        else:
            return student
    except:
        raise UnauthorizedError()


def get_teacher(teacher_token):
    try:
        teacher = memcache.get(teacher_token, "teachers")
        if teacher is None:
            raise RuntimeError("Invalid token")
        else:
            return teacher
    except:
        raise UnauthorizedError()



class UnauthorizedError(RuntimeError):
    "Authorization failed"