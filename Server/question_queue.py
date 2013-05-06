'''
Created on May 4, 2013

@author: "David Lai"
'''
import webapp2
import json
from auth import get_student, get_teacher, UnauthorizedError
from models import StudentQuestionModel, StudentModel




class QuestionQueueHandler(webapp2.RequestHandler):
    
    def debug(self, msg): 
        self.response.out.write(msg + "<br/>")

    def api_fail(self):
        self.response.out.write(json.dumps({'api': 'fail'}))

    def get(self):
        self.post()

    def post(self):
        self.response.headers['Content-Type'] = 'application/json' 
        action = self.request.get("action")
    
        if action == "new":
            self._handle_new_question()
        elif action == "delete":
            self._handle_delete_question()
        elif action == "status":
            self._handle_query_question()
        elif action == "list":
            # only teachers have access to list.
            get_teacher(self.request.get('token'))
            self._handle_list_questions()
        elif action == "answer":
            # only teachers can answer question.
            get_teacher(self.request.get('token'))
            self._handle_answer_question()
        elif action == "setNofify":
            self.__handle_set_notify()
        else:
            raise RuntimeError("invalid request error.")

    def _handle_answer_question(self):
        qid = long(self.request.get("id"))
        student_ques = StudentQuestionModel.get_by_id(qid)
        
        #check if we are authorized teacher.
        get_teacher(self.request.get("token"))
        
        student_ques.status = "answered"
        student_ques.put()
        
        self.response.out.write(json.dumps({'api':'ok'}))


    def _handle_delete_question(self):
        try:
            student_dict = get_student(self.request.get('token'))
        except UnauthorizedError:
            try:
                teacher_dict = get_teacher(self.request.get('token'))
            except UnauthorizedError:
                self.response.out.write(json.dumps({'api':'fail',
                                                    'reason':'unauthorized'}))


        question = StudentQuestionModel.get_by_id(int(self.request.get("id")))
        if question is None:
            self.response.out.write(json.dumps({'api':'fail',
                                                'reason':'question not exist'}))
            return
        # Check if teacher or student owns the question
        if student_dict:
            if student_dict['id'] != question.student.key().id():
                self.response.out.write(json.dumps({'api':'fail',
                                                    'reason':'unauthorized'}))
                return
        elif teacher_dict:
            pass
        else:
            self.response.out.write(json.dumps({'api':'fail',
                                                    'reason':'unauthorized'}))
            return
        
        question.delete()
        self.response.out.write(json.dumps({'api':'ok'}))

    def _handle_list_questions(self):
        questions = StudentQuestionModel.all().order("time_stamp")
        questions_array = []
        for question in questions:
            question_dict = question.get_dict()
            
            # Change any non simple types to '' for serialization.
            self.__scrub_question_dict(question_dict)
             
            questions_array.append(question_dict)
        
        resp = {'api':'ok',
                'questions': questions_array}
        self.response.out.write(json.dumps(resp))


    def _handle_new_question(self):
        student_dict = get_student(self.request.get('token'))
        
        # Create new question entry
        question = StudentQuestionModel()
        question.student = StudentModel.get_by_id(student_dict['id'])
        question.question_text = self.request.get('questionText')
        question.put()
        
        #calculate position of current question.
        position = 0
        all_questions = StudentQuestionModel.all().order("time_stamp") 
        
        for a_question in all_questions:
            if a_question == question:
                break
            position+=1
        
        resp = {'api':'ok',
                'question':question.get_dict(),
                'placeInLine':position
                }
        self.response.out.write(json.dumps(resp))


    def __handle_set_notify(self):
        target_question = StudentQuestionModel.get_by_id(long(self.request.get('id')))
        is_authorized = self.__check_question_authorized_user(target_question)
        
        target_question.notification_type = self.request.get("type")
        target_question.put()
        
        if is_authorized:
            resp = {'api':'ok',
                    'question': self.__scrub_question_dict(target_question.get_dict())}
            self.response.out.write(json.dumps(resp))
        else:
            self.response.out.write(json.dumps({'api':'fail',
                                                'reason':'unauthorized'}))

    def _handle_query_question(self):
        target_question = StudentQuestionModel.get_by_id(long(self.request.get('id')))
        
        is_authorized = self.__check_question_authorized_user(target_question)

        if is_authorized:
            resp = {'api':'ok',
                    'question': self.__scrub_question_dict(target_question.get_dict())}
            self.response.out.write(json.dumps(resp))
        else:
            self.response.out.write(json.dumps({'api':'fail',
                                                'reason':'unauthorized'}))
            

    def __check_question_authorized_user(self, target_question):
        is_authorized = False
        try:
            token = self.request.get("token")
            cached_student_dict = get_student(token)
            print cached_student_dict
            print target_question
            if cached_student_dict['id'] == target_question.student.key().id():
                is_authorized = True
        except:
            try:
                teacher = get_teacher(token)
                if teacher is not None:
                    is_authorized = True
            except:
                pass # authorization failed.
        
        return is_authorized

    def __scrub_question_dict(self, question_dict):
        SIMPLE_TYPES = (int, long, float, bool, dict, basestring, list)
        for key in question_dict.keys():
            if not isinstance(question_dict[key], SIMPLE_TYPES):
                question_dict[key] = ''

        return question_dict