App = Ember.Application.create();

var __route;

// Chat related vars.
var __chatChannel = "";
var __chatName = "";
var __chatLastTimeStamp = 0;
var __chatInterval = null;

App.Router.map(function() {
    // put your routes here
    this.resource('chats', {path: '/chats/:channel/:name'});
});

App.IndexRoute = Ember.Route.extend({
  model: function() {
    return ['red', 'yellow', 'blue'];
  }
});

App.ChatsRoute = Ember.Route.extend({
    model: function(route) {
        __chatChannel = route.channel;
        __chatName = route.name;

        return App.Chat.find();
    },
    activate:function(route) {
        console.log("chat activated");
        console.log(this);


        __chatLastTimeStamp = 0; //reset timestamp.

        __chatInterval = setInterval(function(){
            console.log("polling");
            params = {'action':'getChatLog', 'channel':__chatChannel, 'from': __chatLastTimeStamp}
            console.log("params: " + params);

            $.post("/chat", params,
              function(data) {
                  console.log(data);
                  jsonData = $.parseJSON(data)
                  if(jsonData.chatlog.length > 0) {
                  for (var i=0; i<jsonData.chatlog.length; i++) {
                      if (__chatName != jsonData.chatlog[i].sender || __chatLastTimeStamp == 0) {
                          App.Chat.createRecord({
                              channel: jsonData.chatlog[i].channel,
                              name: jsonData.chatlog[i].sender,
                              message: jsonData.chatlog[i].message
                          })
                      }
                  }
                  __chatLastTimeStamp = jsonData.chatlog[jsonData.chatlog.length-1].timeStamp + 1;
                  console.log("timestamp:" + __chatLastTimeStamp);
                  }

              }
            );
        },1000);
    },
    deactivate: function(route) {
        console.log("chat deactivated");
        clearInterval(__chatInterval);
    }
})


// Controllers
App.ChatsController = Ember.Controller.extend({
    sendChat: function() {
        var message = this.get('newMessage');
        this.set('newMessage', '');
        console.log("message was " + message)
        var newChat = App.Chat.createRecord({
            name: __chatName,
            message: message
        })

        console.log("channel:" + __chatChannel);
        $.post("/chat", {'action':'new', 'channel':__chatChannel, 'sender':__chatName, 'message':message},
              function(data) {
                  console.log(data);
              }
        );
    }
})


// Models

App.Store = DS.Store.extend({
    revision: 12,
    adapter: 'DS.FixtureAdapter'
});


// Implement explicitly to use the object proxy.
App.Chat = DS.Model.extend({
    channel: DS.attr('string'),
    name: DS.attr('string'),
    message: DS.attr('string')
});



//Fixtures
App.Chat.FIXTURES = [

];
