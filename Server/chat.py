'''
Created on May 5, 2013

@author: "David Lai"
'''
import json
import webapp2
from models import ChatModel
import datetime

class ChatHandler(webapp2.RequestHandler):
    '''
    classdocs
    '''

    def debug(self, msg): 
        self.response.out.write(msg + "<br/>")

    def api_fail(self):
        self.response.out.write(json.dumps({'api': 'fail'}))

    def get(self):
        self.post()

    def post(self):
        action = self.request.get("action")
    
        if action == "new":
            self._handle_new_chat()
        elif action == "getChatLog":
            self._handle_get_chat_log()
        else:
            self.api_fail()
            

    def _handle_new_chat(self):
        try:
            chat = ChatModel()
            chat.chat_channel = self.request.get("channel")
            chat.message = self.request.get("message")
            chat.sender = self.request.get("sender")
            
            chat.put()
            self.response.out.write(json.dumps({'api':'ok',
                                     'chat':chat.get_dict()}))
        except:
            self.api_fail()


    def _handle_get_chat_log(self):
        channel = self.request.get("channel")
        if channel in (None, ""):
            self.response.out.write({'api':'fail',
                                     'reason':'invalid channel'})
            return

        try:
            from_time = int(self.request.get("from"))
        except ValueError:
            from_time = 0
        from_timestamp =  datetime.datetime.fromtimestamp(from_time)
        print "timestamp", from_timestamp
        chats = ChatModel.all().filter("chat_channel =", channel)\
        .filter("time_stamp >", from_timestamp).order("time_stamp")

        chatlog = []
        for chat in chats:
            chatlog.append(chat.get_dict())
        
        resp = {'api':'ok',
                'chatlog':chatlog}
        self.response.out.write(json.dumps(resp))
