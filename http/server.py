import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.render('index.html')

class ReSTHandler(tornado.web.RequestHandler):
    pressCount = {}

    def initialize(self, pressCount):
        self.pressCount = pressCount

    def get(self):
        self.write(self.pressCount)
    
    def post(self):
        self.pressCount['count'] += 1
        self.write(self.pressCount)

class Server:

    pressCount = {'count' : 0}

    def start_app(self):
        app = tornado.web.Application([
            (r"/", MainHandler),
            (r"/count", ReSTHandler, {'pressCount': self.pressCount})
        ])
        app.listen(8888)
        tornado.ioloop.IOLoop.current().start()

if __name__ == "__main__":
    server = Server()
    server.start_app()